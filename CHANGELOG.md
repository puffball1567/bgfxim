# Changelog

All notable changes to bgfxim are documented in this file.

## [0.2.0] - 2026-08-21

### Added

- Added exhaustive C/Nim checks for the size and alignment of all 40 complete
  types and the byte offsets of all 418 fields.
- Added direct C/Nim value checks for all 350 constants, 444 enum values, and
  17 state helpers.
- Added a CI matrix covering Linux, macOS, Windows, Nim 2.0/2.2, x86/x64/arm64,
  GCC/Clang, `refc`/`arc`/`orc`, and debug/release configurations.
- Added real NOOP integration jobs for macOS x64 and arm64 alongside Linux.
- Added executed error and boundary FFI coverage for null pointers, rejected
  initialization, version mismatch, allocation failures, invalid handles,
  conflicting flags, validation failures, and release/allocator/fatal callback
  dispatch.
- Added generator rejection tests for missing and duplicate API elements.
- Added a real NOOP demo limited to bgfx's non-fatal validation and negotiation
  failure paths.
- Added AddressSanitizer and UndefinedBehaviorSanitizer execution for the
  synthetic error-path suite.

## [0.1.0] - 2026-08-21

### Added

- Added complete Nim declarations for bgfx C99 API version 155 at revision
  `d8db55f8123a4a0871b1290fec2e5d0caae01bbf`: 208 functions, public structs
  and enums, callback and interface vtables, constants, state helpers, and
  compatibility aliases.
- Added generators for declarations, constants, and an all-signatures compile
  test.
- Added C/Nim ABI assertions and an executed C-stub FFI test covering structs,
  enums, pointers, return values, aliases, and variadic calls.
- Added real bgfx NOOP demos for initialization and resource/encoder lifetime
  paths.
- Added an SDL3 visible demo that passes X11 or Wayland platform data to bgfx
  and executes the OpenGL renderer.
- Added BSD-2-Clause project licensing and complete notices for bgfx, bx, bimg,
  and the optional SDL3 demo dependency.
