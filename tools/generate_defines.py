#!/usr/bin/env python3
"""Generate Nim constants from bgfx's generated defines.h.

Usage: tools/generate_defines.py <path-to-bgfx>/include/bgfx/defines.h bgfx/defines.nim
"""

from __future__ import annotations

import re
import subprocess
import sys
import tempfile
from pathlib import Path


OBJECT_MACRO = re.compile(r"^\s*#\s*define\s+(BGFX_[A-Za-z0-9_]+)(?!\()\s+(.+)$")


def logical_lines(text: str) -> list[str]:
    result: list[str] = []
    current = ""
    for line in text.splitlines():
        current += line
        if current.rstrip().endswith("\\"):
            current = current.rstrip()[:-1] + " "
        else:
            result.append(current)
            current = ""
    if current:
        result.append(current)
    return result


def object_macros(text: str) -> dict[str, str]:
    result: dict[str, str] = {}
    for line in logical_lines(text):
        match = OBJECT_MACRO.match(line)
        if not match:
            continue
        name, expression = match.groups()
        if expression.strip() and name != "BGFX_DEFINES_H_HEADER_GUARD":
            result[name] = expression
    return result


def evaluate(header: Path, names: list[str]) -> dict[str, tuple[int, int, bool]]:
    source = [
        "#include <inttypes.h>",
        "#include <stdbool.h>",
        "#include <stdint.h>",
        "#include <stdio.h>",
        f'#include "{header.as_posix()}"',
        "int main(void) {",
    ]
    for name in names:
        source.append(
            f'  printf("{name} %zu %d %" PRIu64 "\\n", sizeof({name}), '
            f'((__typeof__({name}))-1) < 0, (uint64_t)({name}));'
        )
    source.extend(["  return 0;", "}"])

    with tempfile.TemporaryDirectory(prefix="bgfxim-defines-") as directory:
        directory_path = Path(directory)
        c_path = directory_path / "values.c"
        exe_path = directory_path / "values"
        c_path.write_text("\n".join(source), encoding="utf-8")
        subprocess.run(
            ["cc", "-std=gnu11", "-Werror", str(c_path), "-o", str(exe_path)],
            check=True,
        )
        output = subprocess.run(
            [str(exe_path)], check=True, text=True, capture_output=True
        ).stdout

    values: dict[str, tuple[int, int, bool]] = {}
    for line in output.splitlines():
        name, size, signed, value = line.split()
        values[name] = (int(value), int(size), bool(int(signed)))
    return values


def nim_literal(value: int, size: int, signed: bool) -> str:
    if signed:
        sign_bit = 1 << (size * 8 - 1)
        if value & sign_bit:
            value -= 1 << (size * 8)
        return str(value)
    suffix = {1: "'u8", 2: "'u16", 4: "'u32", 8: "'u64"}[size]
    width = size * 2
    return f"0x{value:0{width}x}{suffix}"


FUNCTION_WIDTHS = {
    "BGFX_STATE_ALPHA_REF": 64,
    "BGFX_STATE_POINT_SIZE": 64,
    "BGFX_STENCIL_FUNC_REF": 32,
    "BGFX_STENCIL_FUNC_RMASK": 32,
    "BGFX_SAMPLER_BORDER_COLOR": 32,
    "BGFX_STATE_BLEND_FUNC_SEPARATE": 64,
    "BGFX_STATE_BLEND_EQUATION_SEPARATE": 64,
    "BGFX_STATE_BLEND_FUNC": 64,
    "BGFX_STATE_BLEND_EQUATION": 64,
}


def semantic_width(name: str, expressions: dict[str, str], seen: set[str]) -> int | None:
    if name in FUNCTION_WIDTHS:
        return FUNCTION_WIDTHS[name]
    if name in seen or name not in expressions:
        return None
    seen.add(name)
    expression = expressions[name]
    explicit = re.findall(r"UINT(8|16|32|64)_C", expression)
    references = re.findall(r"\bBGFX_[A-Za-z0-9_]+\b", expression)
    widths = [int(item) for item in explicit]
    widths.extend(
        width
        for reference in references
        if (width := semantic_width(reference, expressions, seen.copy())) is not None
    )
    return max(widths, default=None)


def generate(header: Path, output: Path) -> None:
    expressions = object_macros(header.read_text(encoding="utf-8"))
    names = list(expressions)
    values = evaluate(header.resolve(), names)
    lines = [
        "# SPDX-License-Identifier: BSD-2-Clause",
        "# Generated from bgfx/include/bgfx/defines.h. Do not edit by hand.",
        "# The binding code is BSD-2-Clause licensed. Constants are derived from",
        "# bgfx's BSD-2-Clause headers. See LICENSE and THIRD_PARTY_NOTICES.md.",
        "",
        "const",
    ]
    for name in names:
        value, size, signed = values[name]
        width = semantic_width(name, expressions, set())
        if width is not None:
            size, signed = width // 8, False
        lines.append(f"  {name}* = {nim_literal(value, size, signed)}")
    lines.extend(
        [
            "",
            "template BGFX_STATE_ALPHA_REF*(value: SomeInteger): uint64 =",
            "  (uint64(value) shl BGFX_STATE_ALPHA_REF_SHIFT) and BGFX_STATE_ALPHA_REF_MASK",
            "",
            "template BGFX_STATE_POINT_SIZE*(value: SomeInteger): uint64 =",
            "  (uint64(value) shl BGFX_STATE_POINT_SIZE_SHIFT) and BGFX_STATE_POINT_SIZE_MASK",
            "",
            "template BGFX_STENCIL_FUNC_REF*(value: SomeInteger): uint32 =",
            "  (uint32(value) shl BGFX_STENCIL_FUNC_REF_SHIFT) and BGFX_STENCIL_FUNC_REF_MASK",
            "",
            "template BGFX_STENCIL_FUNC_RMASK*(value: SomeInteger): uint32 =",
            "  (uint32(value) shl BGFX_STENCIL_FUNC_RMASK_SHIFT) and BGFX_STENCIL_FUNC_RMASK_MASK",
            "",
            "template BGFX_SAMPLER_BORDER_COLOR*(value: SomeInteger): uint32 =",
            "  (uint32(value) shl BGFX_SAMPLER_BORDER_COLOR_SHIFT) and BGFX_SAMPLER_BORDER_COLOR_MASK",
            "",
            "template BGFX_STATE_BLEND_FUNC_SEPARATE*(srcRgb, dstRgb, srcA, dstA: uint64): uint64 =",
            "  (srcRgb or (dstRgb shl 4)) or ((srcA or (dstA shl 4)) shl 8)",
            "",
            "template BGFX_STATE_BLEND_EQUATION_SEPARATE*(equationRgb, equationA: uint64): uint64 =",
            "  equationRgb or (equationA shl 3)",
            "",
            "template BGFX_STATE_BLEND_FUNC*(src, dst: uint64): uint64 =",
            "  BGFX_STATE_BLEND_FUNC_SEPARATE(src, dst, src, dst)",
            "",
            "template BGFX_STATE_BLEND_EQUATION*(equation: uint64): uint64 =",
            "  BGFX_STATE_BLEND_EQUATION_SEPARATE(equation, equation)",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_x*(src, dst: uint64): uint32 =",
            "  uint32((src shr BGFX_STATE_BLEND_SHIFT) or",
            "    ((dst shr BGFX_STATE_BLEND_SHIFT) shl 4))",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_xE*(src, dst, equation: uint64): uint32 =",
            "  BGFX_STATE_BLEND_FUNC_RT_x(src, dst) or",
            "    uint32((equation shr BGFX_STATE_BLEND_EQUATION_SHIFT) shl 8)",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_1*(src, dst: uint64): uint32 =",
            "  BGFX_STATE_BLEND_FUNC_RT_x(src, dst)",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_2*(src, dst: uint64): uint32 =",
            "  BGFX_STATE_BLEND_FUNC_RT_x(src, dst) shl 11",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_3*(src, dst: uint64): uint32 =",
            "  BGFX_STATE_BLEND_FUNC_RT_x(src, dst) shl 22",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_1E*(src, dst, equation: uint64): uint32 =",
            "  BGFX_STATE_BLEND_FUNC_RT_xE(src, dst, equation)",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_2E*(src, dst, equation: uint64): uint32 =",
            "  BGFX_STATE_BLEND_FUNC_RT_xE(src, dst, equation) shl 11",
            "",
            "template BGFX_STATE_BLEND_FUNC_RT_3E*(src, dst, equation: uint64): uint32 =",
            "  BGFX_STATE_BLEND_FUNC_RT_xE(src, dst, equation) shl 22",
            "",
        ]
    )
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    generate(Path(sys.argv[1]), Path(sys.argv[2]))


if __name__ == "__main__":
    main()
