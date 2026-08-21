#!/usr/bin/env python3
"""Generate a compile-only test that references every bgfx C99 function."""

from __future__ import annotations

import sys
from pathlib import Path

sys.dont_write_bytecode = True

from update_bindings import Function, parse_functions


def call(function: Function, index: int) -> tuple[list[str], str]:
    declarations: list[str] = []
    arguments: list[str] = []
    for parameter_index, parameter in enumerate(function.parameters):
        nim_type = parameter.nim_type
        if nim_type.startswith("var "):
            local = f"argument{index}_{parameter_index}"
            declarations.append(f"  var {local}: {nim_type.removeprefix('var ')}")
            arguments.append(local)
        else:
            arguments.append(f"default({nim_type})")
    invocation = f"BGFX.{function.nim_name}({', '.join(arguments)})"
    if function.return_type:
        invocation = "discard " + invocation
    return declarations, "  " + invocation


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(
            "usage: generate_signature_test.py <bgfx/c99/bgfx.h> <output.nim>"
        )
    header = Path(sys.argv[1]).read_text(encoding="utf-8")
    functions = parse_functions(header)
    lines = ["import bgfx", "", "proc exerciseAll*() {.exportc.} ="]
    for index, function in enumerate(functions):
        declarations, invocation = call(function, index)
        lines.extend(declarations)
        lines.append(invocation)
    Path(sys.argv[2]).write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
