# Changelog

All notable changes to bgfxim are documented in this file.

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
