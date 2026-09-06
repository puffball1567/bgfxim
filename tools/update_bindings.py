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
DOCUMENTED_DECLARATION = re.compile(
    r"/\*\*((?:(?!/\*\*).)*?)\*/\s*BGFX_C_API\s+.+?\s+"
    r"(bgfx_[a-z0-9_]+)\(",
    re.DOTALL,
)
ARRAY_PARAMETER = re.compile(r"^(.+?)\s+(_[A-Za-z0-9_]+)\s*\[(\d+)\]$")
PARAMETER = re.compile(r"^(.+?)\s+(_[A-Za-z0-9_]+)$")
PARAMETER_DOCUMENTATION = re.compile(
    r"^@param(?:\[([^]]+)\])?(?:\s+(_[A-Za-z0-9_]+))?(?:\s+(.*))?$"
)
NIM_KEYWORDS = {"discard", "enum", "ptr", "type"}
SPECIAL_NAMES = {
    "bgfx_topology_convert": "bgfx_topology_convert_call",
    "bgfx_render_frame": "bgfx_render_frame_call",
}

TYPE_DOCUMENTATION_REFERENCES = {
    "Access": "bgfx_access_t",
    "Attachment": "bgfx_attachment_t",
    "Attrib": "bgfx_attrib_t",
    "AttribType": "bgfx_attrib_type_t",
    "BackbufferRatio": "bgfx_backbuffer_ratio_t",
    "BufferRegion": "bgfx_buffer_region_t",
    "CallbackI": "bgfx_callback_interface_t",
    "Init": "bgfx_init_t",
    "ReleaseFn": "bgfx_release_fn_t",
    "RenderFrame": "bgfx_render_frame_t",
    "RendererType": "bgfx_renderer_type_t",
    "SwapChain": "bgfx_swap_chain_t",
    "TextureFormat": "bgfx_texture_format_t",
    "TextureInfo": "bgfx_texture_info_t",
    "TextureRegion": "bgfx_texture_region_t",
    "TopologyConvert": "bgfx_topology_convert_t",
    "TopologySort": "bgfx_topology_sort_t",
    "Transform": "bgfx_transform_t",
    "UniformFreq": "bgfx_uniform_freq_t",
    "UniformType": "bgfx_uniform_type_t",
    "VideoCodec": "bgfx_video_codec_t",
    "VideoDecoderFrame": "bgfx_video_decoder_frame_t",
    "ViewMode": "bgfx_view_mode_t",
}

ENUM_DOCUMENTATION_REFERENCES = {
    "Access",
    "Attrib",
    "AttribType",
    "BackbufferRatio",
    "RenderFrame",
    "RendererType",
    "TextureFormat",
    "TopologyConvert",
    "TopologySort",
    "UniformFreq",
    "UniformType",
    "VideoCodec",
    "ViewMode",
}


@dataclass(frozen=True)
class Parameter:
    name: str
    nim_type: str


@dataclass(frozen=True)
class ParameterDocumentation:
    name: str
    direction: str
    lines: tuple[str, ...]


@dataclass(frozen=True)
class Documentation:
    description: tuple[str, ...]
    parameters: tuple[ParameterDocumentation, ...]
    returns: tuple[str, ...]
    remarks: tuple[str, ...]
    attention: tuple[str, ...]
    warning: tuple[str, ...]


@dataclass(frozen=True)
class Function:
    c_name: str
    return_type: str | None
    parameters: tuple[Parameter, ...]
    variadic: bool
    documentation: Documentation

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


def cpp_identifier_to_snake(name: str) -> str:
    result = re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "_", name).lower()
    result = re.sub(r"(?<=[a-z])(?=[0-9])", "_", result)
    return re.sub(r"_([123])_d\b", r"_\1d", result)


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


def trim_empty(lines: list[str]) -> tuple[str, ...]:
    while lines and not lines[0]:
        lines.pop(0)
    while lines and not lines[-1]:
        lines.pop()
    return tuple(lines)


def parse_documentation(comment: str) -> Documentation:
    description: list[str] = []
    parameter_docs: list[tuple[str, str, list[str]]] = []
    returns: list[str] = []
    remarks: list[str] = []
    attention: list[str] = []
    warning: list[str] = []
    active = description

    for source_line in comment.splitlines():
        line = re.sub(r"^\s*\* ?", "", source_line).strip()
        parameter_match = PARAMETER_DOCUMENTATION.match(line)
        if parameter_match:
            direction, name, first_line = parameter_match.groups()
            if name is None:
                active = []
                continue
            lines = [first_line or ""]
            parameter_docs.append((identifier(name), direction or "", lines))
            active = lines
            continue

        directive = re.match(
            r"^@(returns|remarks?|attention|warning)(?:\s+(.*))?$", line
        )
        if directive:
            kind, first_line = directive.groups()
            destination = {
                "returns": returns,
                "remark": remarks,
                "remarks": remarks,
                "attention": attention,
                "warning": warning,
            }[kind]
            if destination and destination[-1]:
                destination.append("")
            if first_line:
                destination.append(first_line)
            active = destination
            continue

        active.append(line)

    return Documentation(
        trim_empty(description),
        tuple(
            ParameterDocumentation(name, direction, trim_empty(lines))
            for name, direction, lines in parameter_docs
        ),
        trim_empty(returns),
        trim_empty(remarks),
        trim_empty(attention),
        trim_empty(warning),
    )


def parse_documentation_by_name(header: str) -> dict[str, Documentation]:
    result = {
        c_name: parse_documentation(comment)
        for comment, c_name in DOCUMENTED_DECLARATION.findall(header)
    }
    if len(result) != 215:
        raise ValueError(
            f"expected upstream documentation for 215 functions, found {len(result)}"
        )
    # bgfx_get_interface is declared with an empty /**/ marker in the C99 header.
    result["bgfx_get_interface"] = Documentation(
        ("Return the C99 interface vtable for a matching API version.",),
        (
            ParameterDocumentation(
                "version", "in", ("Requested `BGFX_API_VERSION` value.",)
            ),
        ),
        ("Interface vtable, or `nil` when `version` does not match.",),
        (),
        (),
        (),
    )
    return result


def parse_functions(header: str) -> list[Function]:
    result: list[Function] = []
    documentation = parse_documentation_by_name(header)
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
            Function(
                c_name,
                translate_type(c_return_type),
                tuple(parameters),
                variadic,
                documentation[c_name],
            )
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


def nim_documentation_text(text: str, function: Function) -> str:
    def replace_bgfx_reference(match: re.Match[str]) -> str:
        reference = match.group(1)
        parts = reference.split("::")
        if parts[0] in TYPE_DOCUMENTATION_REFERENCES:
            base = TYPE_DOCUMENTATION_REFERENCES[parts[0]]
            if len(parts) == 1:
                return base
            if parts[0] == "CallbackI" and parts[1] == "screenShot":
                return base + ".screen_shot"
            if parts[0] == "UniformFreq" and parts[1] == "View":
                return "BGFX_UNIFORM_FREQ_VIEW"
            return base + "." + ".".join(parts[1:])

        suffix = "()" if reference.endswith("()") else ""
        name = reference.removesuffix("()")
        snake_name = cpp_identifier_to_snake(name)
        return f"BGFX.{snake_name}{suffix}"

    result = re.sub(r"bgfx::([A-Za-z0-9_:]+(?:\(\))?)", replace_bgfx_reference, text)
    result = result.replace("Caps::supported", "bgfx_caps_t.supported")
    result = result.replace("Caps::codecs", "bgfx_caps_t.codecs")

    def replace_enum_reference(match: re.Match[str]) -> str:
        type_name, value_name = match.groups()
        if type_name not in ENUM_DOCUMENTATION_REFERENCES:
            return match.group(0)
        if value_name == "Enum":
            return TYPE_DOCUMENTATION_REFERENCES[type_name]
        return "BGFX_" + cpp_identifier_to_snake(
            type_name + "_" + value_name
        ).upper()

    result = re.sub(
        r"\b([A-Z][A-Za-z0-9]*)::([A-Z][A-Za-z0-9]*)\b",
        replace_enum_reference,
        result,
    )
    for cpp_name, nim_name in TYPE_DOCUMENTATION_REFERENCES.items():
        result = result.replace(f"{cpp_name}::Enum", nim_name)
        result = result.replace(f"`{cpp_name}`", f"`{nim_name}`")
    result = re.sub(r"`_([A-Za-z][A-Za-z0-9_]*)`", r"`\1`", result)
    for parameter in function.parameters:
        name = parameter.name.strip("`")
        result = result.replace(f"`_{name}`", f"`{name}`")
        result = re.sub(rf"\b_{re.escape(name)}\b", name, result)
    # Nim's documentation renderer uses reStructuredText. Keep diagrams and
    # upstream prose containing list-like prefixes from being parsed as markup.
    result = re.sub(r"^(\d+)\.", r"\1\\.", result)
    result = re.sub(r"^([-+|^])", r"\\\1", result)
    return result


def documentation_lines(lines: tuple[str, ...], function: Function) -> list[str]:
    return [nim_documentation_text(line, function) for line in lines]


def proc_documentation(function: Function) -> str:
    documentation = function.documentation
    output = ["##" if not line else f"## {line}" for line in documentation_lines(
        documentation.description, function
    )]

    documented_parameters = {
        item.name.strip("`"): item for item in documentation.parameters
    }
    missing_parameters = [
        item.name.strip("`")
        for item in function.parameters
        if item.name.strip("`") not in documented_parameters
        and item.name.strip("`") != "this"
    ]
    if missing_parameters:
        raise ValueError(
            f"{function.c_name} has undocumented parameters: "
            + ", ".join(missing_parameters)
        )

    if function.parameters:
        if output:
            output.append("##")
        output.append("## **Parameters:**")
        for parameter in function.parameters:
            name = parameter.name.strip("`")
            item = documented_parameters.get(name)
            if item is None:
                if "encoder" in parameter.nim_type:
                    lines = ["Encoder instance."]
                elif "vertex_layout" in parameter.nim_type:
                    lines = ["Vertex layout instance."]
                else:
                    lines = ["Target object instance."]
                direction = "in"
            else:
                lines = documentation_lines(item.lines, function)
                direction = item.direction.replace(",", "/")
            qualifier = f" ({direction})" if direction else ""
            first_line = lines[0] if lines else ""
            output.append(f"## - `{name}`{qualifier}: {first_line}".rstrip())
            output.extend(
                "##" if not line else f"##   {line}" for line in lines[1:]
            )

    for title, lines in (
        ("Returns", documentation.returns),
        ("Remarks", documentation.remarks),
        ("Attention", documentation.attention),
        ("Warning", documentation.warning),
    ):
        if not lines:
            continue
        if output:
            output.append("##")
        output.append(f"## **{title}:**")
        output.extend(
            "##" if not line else f"## {line}"
            for line in documentation_lines(lines, function)
        )

    if not output:
        raise ValueError(f"{function.c_name} has empty documentation")
    return "\n".join("  " + line for line in output)


def documented_proc_declaration(function: Function) -> str:
    return proc_declaration(function) + "\n" + proc_documentation(function)


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


def function_id_enum(functions: list[Function]) -> str:
    entries = [item for item in functions if item.c_name != "bgfx_get_interface"]
    lines = [
        '  bgfx_function_id* {.importc: "bgfx_function_id_t", '
        'header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum'
    ]
    lines.extend(
        f"    BGFX_FUNCTION_ID_{item.short_name.upper()} = {index}"
        for index, item in enumerate(entries)
    )
    lines.append(f"    BGFX_FUNCTION_ID_COUNT = {len(entries)}")
    lines.append("  bgfx_function_id_t* = bgfx_function_id")
    return "\n".join(lines)


def update(header_path: Path, binding_path: Path) -> None:
    functions = parse_functions(header_path.read_text(encoding="utf-8"))
    if len(functions) != 216:
        raise ValueError(f"expected 216 functions, found {len(functions)}")

    binding = binding_path.read_text(encoding="utf-8")

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

    binding, replacements = re.subn(
        r'  bgfx_function_id\* .*?\n  bgfx_function_id_t\* = bgfx_function_id',
        function_id_enum(functions),
        binding,
        count=1,
        flags=re.DOTALL,
    )
    if replacements != 1:
        raise ValueError("could not replace function id enum")

    marker = "# Compatibility aliases for the original generated names"
    declaration_start = re.search(
        r'^proc\s+.*?\{\.importc:\s*"bgfx_[a-z0-9_]+"',
        binding,
        re.MULTILINE,
    )
    marker_start = binding.find(marker)
    if declaration_start is None or marker_start < declaration_start.start():
        raise ValueError("could not locate generated declaration block")
    declarations = "\n\n".join(
        documented_proc_declaration(item) for item in functions
    )
    binding = (
        binding[: declaration_start.start()].rstrip()
        + "\n\n\n"
        + declarations
        + "\n\n"
        + binding[marker_start:]
    )

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
