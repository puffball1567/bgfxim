# Changelog

All notable changes to bgfxim are documented in this file.

## [Unreleased]

## [0.4.0] - 2026-09-06

### Changed

- Updated the complete low-level binding from bgfx API 155 to API 159,
  including the new swap-chain, texture-region, buffer-region, buffer-readback,
  and region-blit APIs.
- Updated the pinned bgfx, bx, and bimg revisions and migrated the examples to
  bgfx's swap-chain initialization and reset model.
- Followed upstream's breaking initialization changes: native window handles
  now live in `bgfx_init_t.swapChain`, device reset flags live in
  `bgfx_init_t.reset`, and `BGFX.reset` and `BGFX.setDebug` use their API 159
  signatures.
- Removed the C99 calls that upstream removed: `set_platform_data`,
  `create_frame_buffer_from_nwh`, `override_internal_texture_ptr`, and
  `override_internal_texture`.

## [0.3.0] - 2026-08-23

### Added

- Added Nim language-server documentation for all 208 public calls, including
  purpose, parameter directions, returns, remarks, ownership and threading
  constraints, and warnings from the pinned bgfx C99 API.
- Added a reproducible HTML API-reference command and CI documentation build.
- Added a responsive GitHub Pages theme with a persistent left sidebar, API
  search, light and dark modes, mobile navigation, and release metadata.
- Expanded the SDL3/OpenGL demo into a real triangle submission covering
  vertex/index buffers, shader and program creation, pipeline state, submit,
  frames, and ordered resource destruction.
- Added a Linux CI smoke test that runs the OpenGL renderer through SDL3 and
  X11 under Xvfb with Mesa software rendering.
- Added focused example documentation for interactive and finite-frame demo
  execution.

## [0.2.0] - 2026-08-22

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

### Fixed

- Preserved `const` qualifiers for callback string and data parameters so
  user callbacks compile cleanly with strict Clang and GCC toolchains.
- Added the bx compatibility include and native framework links required by the
  real NOOP demos on macOS.

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
