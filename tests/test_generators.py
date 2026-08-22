#!/usr/bin/env python3
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

import re
import sys
import unittest
from dataclasses import replace
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.dont_write_bytecode = True
sys.path.insert(0, str(ROOT / "tools"))

import generate_abi_test
import generate_value_test
import update_bindings


class DocumentationGeneratorTests(unittest.TestCase):
    def test_current_surface_documents_every_imported_call(self) -> None:
        binding = (ROOT / "bgfx.nim").read_text(encoding="utf-8")
        documented_calls = re.findall(
            r'(?:(?:^##[^\n]*\n)+)^proc\s+.*?\{\.importc:\s*"bgfx_',
            binding,
            re.MULTILINE,
        )

        self.assertEqual(208, len(documented_calls))
        self.assertNotRegex(binding, r'(?m)^proc .*\n  ##')

    def test_only_the_adjacent_doxygen_block_is_selected(self) -> None:
        header = """
        /** Unrelated type documentation. */
        typedef int unrelated_type;
        /** Call documentation. */
        BGFX_C_API void bgfx_example(void);
        """

        matches = update_bindings.DOCUMENTED_DECLARATION.findall(header)

        self.assertEqual([(" Call documentation. ", "bgfx_example")], matches)

    def test_doxygen_sections_are_rendered_for_nim_lsp(self) -> None:
        documentation = update_bindings.parse_documentation(
            """
            * Submit a frame with `bgfx::submit`.
            *
            * @param[in] _viewId View identifier.
            * @param[in,out] _state Mutable state.
            * @returns Submission identifier.
            * @remarks Call after `bgfx::init`.
            * @attention Keep `_state` alive.
            * @warning Do not reuse invalid state.
            """
        )
        function = update_bindings.Function(
            "bgfx_example",
            "uint32",
            (
                update_bindings.Parameter("viewId", "uint16"),
                update_bindings.Parameter("state", "ptr uint32"),
            ),
            False,
            documentation,
        )

        output = update_bindings.proc_documentation(function)

        self.assertIn("## Submit a frame with `BGFX.submit`.", output)
        self.assertIn("## - `viewId` (in): View identifier.", output)
        self.assertIn("## - `state` (in/out): Mutable state.", output)
        self.assertIn("## **Returns:**", output)
        self.assertIn("## **Remarks:**", output)
        self.assertIn("## **Attention:**", output)
        self.assertIn("## **Warning:**", output)
        self.assertIn("Keep `state` alive.", output)

    def test_cpp_type_references_use_nim_names(self) -> None:
        documentation = update_bindings.Documentation(
            (
                "Use `bgfx::RendererType`, `TextureFormat::Enum`, and "
                "`bgfx::createTexture2D`.",
            ),
            (),
            (),
            (),
            (),
            (),
        )
        function = update_bindings.Function(
            "bgfx_example", None, (), False, documentation
        )

        output = update_bindings.proc_documentation(function)

        self.assertIn("`bgfx_renderer_type_t`", output)
        self.assertIn("`bgfx_texture_format_t`", output)
        self.assertIn("`BGFX.create_texture_2d`", output)

    def test_undocumented_parameter_is_rejected(self) -> None:
        function = update_bindings.Function(
            "bgfx_example",
            None,
            (update_bindings.Parameter("value", "uint32"),),
            False,
            update_bindings.Documentation(
                ("Example.",), (), (), (), (), ()
            ),
        )

        with self.assertRaisesRegex(ValueError, "undocumented parameters: value"):
            update_bindings.proc_documentation(function)

    def test_documentation_output_is_deterministic(self) -> None:
        documentation = update_bindings.Documentation(
            ("Example.",), (), ("Done.",), (), (), ()
        )
        function = update_bindings.Function(
            "bgfx_example", "bool", (), False, documentation
        )

        self.assertEqual(
            update_bindings.proc_documentation(function),
            update_bindings.proc_documentation(function),
        )


class AbiGeneratorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.binding = (ROOT / "bgfx.nim").read_text(encoding="utf-8")
        cls.objects = generate_abi_test.parse_objects(cls.binding)

    def test_current_surface_has_expected_shape(self) -> None:
        self.assertEqual(40, len(self.objects))
        self.assertEqual(418, sum(len(item.fields) for item in self.objects))

    def test_missing_type_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "expected 40 imported objects"):
            generate_abi_test.generate(self.objects[:-1])

    def test_duplicate_type_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "expected 40 imported objects"):
            generate_abi_test.generate(self.objects + [self.objects[0]])

    def test_missing_field_is_rejected(self) -> None:
        damaged = list(self.objects)
        damaged[0] = replace(damaged[0], fields=damaged[0].fields[:-1])
        with self.assertRaisesRegex(ValueError, "expected 418 fields"):
            generate_abi_test.generate(damaged)

    def test_duplicate_field_is_rejected(self) -> None:
        damaged = list(self.objects)
        damaged[0] = replace(
            damaged[0], fields=damaged[0].fields + (damaged[0].fields[0],)
        )
        with self.assertRaisesRegex(ValueError, "expected 418 fields"):
            generate_abi_test.generate(damaged)

    def test_nim_keyword_field_is_quoted(self) -> None:
        output = generate_abi_test.generate(self.objects)
        self.assertIn("offsetOf(bgfx_interface_vtbl, `discard`)", output)


class ValueGeneratorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        binding = (ROOT / "bgfx.nim").read_text(encoding="utf-8")
        defines = (ROOT / "bgfx" / "defines.nim").read_text(encoding="utf-8")
        cls.constants = generate_value_test.names(
            generate_value_test.CONSTANT, defines
        )
        cls.enum_values = generate_value_test.names(
            generate_value_test.ENUM, binding
        )

    def test_current_surface_has_expected_shape(self) -> None:
        self.assertEqual(350, len(self.constants))
        self.assertEqual(444, len(self.enum_values))

    def test_missing_constant_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "expected 350 constants"):
            generate_value_test.generate(self.constants[:-1], self.enum_values)

    def test_duplicate_constant_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "expected 350 constants"):
            generate_value_test.generate(
                self.constants + [self.constants[0]], self.enum_values
            )

    def test_missing_enum_value_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "expected 444 enum values"):
            generate_value_test.generate(self.constants, self.enum_values[:-1])

    def test_duplicate_enum_value_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "expected 444 enum values"):
            generate_value_test.generate(
                self.constants, self.enum_values + [self.enum_values[0]]
            )

    def test_output_is_deterministic_and_contains_all_helpers(self) -> None:
        first = generate_value_test.generate(self.constants, self.enum_values)
        second = generate_value_test.generate(self.constants, self.enum_values)
        self.assertEqual(first, second)
        for helper, arguments in generate_value_test.HELPERS:
            self.assertIn(f"{helper}({arguments})", first)


if __name__ == "__main__":
    unittest.main()
