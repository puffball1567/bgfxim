#!/usr/bin/env python3
# SPDX-License-Identifier: BSD-2-Clause
"""Update generated declarations in bgfx.nim from bgfx's C99 header.

Usage: tools/update_bindings.py <path-to-bgfx>/include/bgfx/c99/bgfx.h bgfx.nim
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path


DECLARATION = re.compile(r"^BGFX_C_API\s+(.+?)\s+(bgfx_[a-z0-9_]+)\((.*)\);$")
ARRAY_PARAMETER = re.compile(r"^(.+?)\s+(_[A-Za-z0-9_]+)\s*\[(\d+)\]$")
PARAMETER = re.compile(r"^(.+?)\s+(_[A-Za-z0-9_]+)$")
NIM_KEYWORDS = {"discard", "enum", "ptr", "type"}
SPECIAL_NAMES = {
    "bgfx_topology_convert": "bgfx_topology_convert_call",
    "bgfx_render_frame": "bgfx_render_frame_call",
}


@dataclass(frozen=True)
class Parameter:
    name: str
    nim_type: str


@dataclass(frozen=True)
class Function:
    c_name: str
    return_type: str | None
    parameters: tuple[Parameter, ...]
    variadic: bool

    @property
    def nim_name(self) -> str:
        return identifier(self.short_name)

    @property
    def compatibility_name(self) -> str:
        return SPECIAL_NAMES.get(self.c_name, self.c_name)

    @property
    def short_name(self) -> str:
        return self.c_name.removeprefix("bgfx_")


BASE_TYPES = {
    "bool": "bool",
    "char": "cchar",
    "float": "cfloat",
    "int16_t": "int16",
    "int32_t": "int32",
    "int64_t": "int64",
    "size_t": "csize_t",
    "uintptr_t": "uint",
    "uint8_t": "uint8",
    "uint16_t": "uint16",
    "uint32_t": "uint32",
    "uint64_t": "uint64",
    "va_list": "bgfx_va_list_t",
    "void": "void",
}


def identifier(name: str) -> str:
    name = name.removeprefix("_")
    return f"`{name}`" if name in NIM_KEYWORDS else name


def translate_type(c_type: str) -> str | None:
    c_type = re.sub(r"\s+", " ", c_type.strip())
    c_type = re.sub(r"\bconst\b", "", c_type)
    c_type = re.sub(r"\s+", " ", c_type).strip()
    pointer_count = c_type.count("*")
    base = c_type.replace("*", "").strip()
    nim_base = BASE_TYPES.get(base, base)
    if pointer_count:
        if base == "void":
            nim_type = "pointer"
        elif base == "char" and pointer_count == 1:
            nim_type = "cstring"
        else:
            nim_type = ("ptr " * pointer_count) + nim_base
        return nim_type
    return None if base == "void" else nim_base


def translate_parameter(c_parameter: str) -> Parameter | None:
    c_parameter = c_parameter.strip()
    if c_parameter == "void":
        return None
    array_match = ARRAY_PARAMETER.match(c_parameter)
    if array_match:
        c_type, name, length = array_match.groups()
        is_const = "const" in c_type.split()
        nim_base = translate_type(c_type)
        assert nim_base is not None
        nim_type = f"array[{length}, {nim_base}]"
        if not is_const:
            nim_type = "var " + nim_type
        return Parameter(identifier(name), nim_type)
    match = PARAMETER.match(c_parameter)
    if not match:
        raise ValueError(f"cannot parse parameter: {c_parameter}")
    c_type, name = match.groups()
    nim_type = translate_type(c_type)
    assert nim_type is not None
    return Parameter(identifier(name), nim_type)


def parse_functions(header: str) -> list[Function]:
    result: list[Function] = []
    for line in header.splitlines():
        match = DECLARATION.match(line)
        if not match:
            continue
        c_return_type, c_name, c_parameters = match.groups()
        variadic = False
        parameters: list[Parameter] = []
        for c_parameter in c_parameters.split(","):
            if c_parameter.strip() == "...":
                variadic = True
                continue
            parameter = translate_parameter(c_parameter)
            if parameter is not None:
                parameters.append(parameter)
        result.append(
            Function(c_name, translate_type(c_return_type), tuple(parameters), variadic)
        )
    return result


def parameter_list(function: Function, namespace: bool) -> str:
    parameters = [f"{item.name}: {item.nim_type}" for item in function.parameters]
    if namespace:
        parameters.insert(0, "_: type BGFX")
    return "; ".join(parameters)


def proc_declaration(function: Function) -> str:
    result = f"proc {function.nim_name}*({parameter_list(function, True)})"
    if function.return_type:
        result += f": {function.return_type}"
    pragmas = [f'importc: "{function.c_name}"', "cdecl"]
    if function.variadic:
        pragmas.append("varargs")
    pragmas.append('header: "bgfx/c99/bgfx.h"')
    return result + " {." + ", ".join(pragmas) + ".}"


def vtable_field(function: Function) -> str:
    name = identifier(function.short_name)
    result = f"    {name}*: proc({parameter_list(function, False)})"
    if function.return_type:
        result += f": {function.return_type}"
    pragmas = ["cdecl"]
    if function.variadic:
        pragmas.append("varargs")
    return result + " {." + ", ".join(pragmas) + ".}"


def wrapper(function: Function) -> str:
    name = function.compatibility_name
    if not function.parameters and not function.variadic:
        return (
            f"template {name}*(_: type BGFX): untyped =\n"
            f"  BGFX.{function.nim_name}()"
        )
    return (
        f"template {name}*(_: type BGFX; args: varargs[untyped]): untyped =\n"
        f"  BGFX.{function.nim_name}(args)"
    )


def update(header_path: Path, binding_path: Path) -> None:
    functions = parse_functions(header_path.read_text(encoding="utf-8"))
    if len(functions) != 208:
        raise ValueError(f"expected 208 functions, found {len(functions)}")

    binding = binding_path.read_text(encoding="utf-8")
    by_c_name = {function.c_name: function for function in functions}

    declaration_line = re.compile(
        r'^proc\s+(?:\w+|`\w+`)\*\(.*?\{\.importc:\s*"(bgfx_[a-z0-9_]+)".*$',
        re.MULTILINE,
    )

    def replace_declaration(match: re.Match[str]) -> str:
        return proc_declaration(by_c_name[match.group(1)])

    binding, replacements = declaration_line.subn(replace_declaration, binding)
    if replacements != 208:
        raise ValueError(f"expected to replace 208 declarations, replaced {replacements}")

    vtable_functions = [item for item in functions if item.c_name != "bgfx_get_interface"]
    vtable = (
        '  bgfx_interface_vtbl* {.importc: "bgfx_interface_vtbl_t", '
        'header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object\n'
        + "\n".join(vtable_field(item) for item in vtable_functions)
        + "\n"
    )
    binding, replacements = re.subn(
        r'  bgfx_interface_vtbl\* .*? = object\n.*?(?=  bgfx_callback_interface_s\*)',
        vtable,
        binding,
        count=1,
        flags=re.DOTALL,
    )
    if replacements != 1:
        raise ValueError("could not replace interface vtable")

    marker = "# Compatibility aliases for the original generated names"
    for old_marker in (marker, "# Idiomatic namespace aliases"):
        binding = binding.split(old_marker, 1)[0].rstrip()
    binding += "\n\n" + marker + "\n"
    binding += "\n\n".join(wrapper(item) for item in functions) + "\n"
    binding_path.write_text(binding, encoding="utf-8")


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    update(Path(sys.argv[1]), Path(sys.argv[2]))


if __name__ == "__main__":
    main()
