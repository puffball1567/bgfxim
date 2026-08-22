#!/usr/bin/env python3
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

import sys
import unittest
from dataclasses import replace
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.dont_write_bytecode = True
sys.path.insert(0, str(ROOT / "tools"))

import generate_abi_test
import generate_value_test


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
