# bgfxim

**Complete, low-level Nim bindings for bgfx's generated C99 API.**

[![CI](https://github.com/puffball1567/bgfxim/actions/workflows/ci.yml/badge.svg)](https://github.com/puffball1567/bgfxim/actions/workflows/ci.yml)
[![License: BSD-2-Clause](https://img.shields.io/badge/License-BSD--2--Clause-blue.svg)](LICENSE)

bgfxim exposes bgfx without introducing a second rendering abstraction. It
tracks one exact upstream API revision, keeps the original C-compatible types,
and adds typed `BGFX` namespace calls that read naturally in Nim. Applications
remain responsible for building and linking bgfx, bx, and bimg for their target
platform and renderer backends.

## Why bgfxim

- **Complete C99 surface.** All 216 functions, public structs, enums, callback
  and interface vtables, 334 object-like constants, and 17 state helpers are
  available.
- **Auditable ABI.** Imported objects use the C typedef names from bgfx's
  generated header. The test suite compares all 43 complete public types for
  size and alignment and all 443 fields for byte offset with the C compiler.
- **Mechanical updates.** Checked-in generators update declarations and
  constants from upstream generated headers instead of relying on manual
  transcription.
- **Real execution coverage.** Tests cross the Nim/C boundary, initialize the
  real NOOP renderer, exercise resource, encoder, and non-fatal validation
  paths, and submit a real OpenGL triangle through an SDL3 native window.
- **Thin by design.** The binding preserves bgfx ownership and threading rules;
  higher-level rendering APIs can be built independently.
- **Editor-ready reference.** All 216 public calls include Nim documentation
  for their purpose, parameters, return value, and upstream constraints.

## Project Direction

bgfxim intentionally remains a faithful, low-level binding. Its long-term work
is expected to center on upstream bgfx version tracking, generator correctness,
ABI and runtime coverage, platform validation, documentation, and focused
demos.

High-level renderers, automatic resource management, window integration,
shader or asset pipelines, frame graphs, and engine-style convenience APIs
should be built as separate packages on top of bgfxim. This keeps the binding
close to upstream bgfx and allows users to choose or design the abstraction
that fits their application. See [CONTRIBUTING.md](CONTRIBUTING.md) for the
detailed scope and contribution criteria.

## Status

Version `0.4.0` targets bgfx API version 159 at revision
`8c8b6b5692be5054e89d2a59640c50b9319c9425`.

The release has been exercised with:

- Nim 2.2.10 on Linux x86_64;
- bx revision `98ad3bec2a7ee1a5cbabdcabc25252572dcb1d88`;
- bimg revision `ddbeeae05779f84f97694553eb41605a60f86f0a`;
- the real bgfx NOOP and OpenGL 4.3 renderers;
- SDL 3.4.14 with X11 native-window integration.

CI also runs the complete compile/ABI/value/FFI suite across Linux, macOS, and
Windows with Nim 2.0 and 2.2. Its focused matrix covers x86, x86_64, and arm64;
GCC and Clang; `refc`, `arc`, and `orc`; and debug and release builds. Real
NOOP integration runs on Linux x86_64 plus macOS x86_64 and arm64. The Linux
Clang error-path test additionally runs under AddressSanitizer and
UndefinedBehaviorSanitizer. A separate Linux job builds SDL3, opens an X11
window under Xvfb, selects Mesa software rendering, and submits a triangle
through the real bgfx OpenGL backend.

The API is complete for the pinned revision, but not every function has been
executed on every renderer or platform. See [Current Boundaries](#current-boundaries).

## Try It

### 1. Requirements

- Nim 2.0 or newer;
- a C++20 compiler for the tested bgfx/bx/bimg revisions;
- matching bgfx, bx, and bimg source trees or prebuilt libraries;
- SDL3 development files for the optional visible demo.

bgfx's C99 header includes `bx/platform.h`, so both the bgfx and bx include
directories must be visible to the C compiler.

### 2. Install the binding

```sh
nimble install https://github.com/puffball1567/bgfxim@#v0.4.0
```

The repository contains the source bindings, generators, documentation, tests,
and examples. The installed package does not bundle native bgfx, bx, bimg, or
SDL binaries.

### 3. Initialize bgfx

```nim
import bgfx

var init: bgfx_init_t
BGFX.initCtor(addr init)
init.swapChain.width = 1280
init.swapChain.height = 720
init.reset = BGFX_RESET_VSYNC

if not BGFX.init(addr init):
  raise newException(IOError, "bgfx initialization failed")

try:
  BGFX.setDebug(BGFX_DEBUG_TEXT,
    invalidHandle(bgfx_frame_buffer_handle_t), 1)
  BGFX.touch(0)
  discard BGFX.frame(BGFX_FRAME_NONE)
finally:
  BGFX.shutdown()
```

Platform applications must populate `init.swapChain` with the native window
and display handles and set `init.platformData.type` before initialization. The
SDL3 demo contains a compact X11/Wayland example.

### 4. Compile and link

Supply the matching headers and libraries in dependency order. Platform and
renderer-specific system libraries may also be required:

```sh
nim c --path:. \
  --passC:-I<path-to-bgfx>/include \
  --passC:-I<path-to-bx>/include \
  --passL:<path-to-built-bgfx-library> \
  --passL:<path-to-built-bimg-library> \
  --passL:<path-to-built-bx-library> \
  app.nim
```

Typed functions use the `BGFX` namespace. Their Nim names omit the `bgfx_`
prefix and may be written in camelCase because Nim identifiers are
case-insensitive. Original names such as `BGFX.bgfx_init` remain available as
compatibility aliases. Use `invalidHandle(bgfx_texture_handle_t)` and
`BGFX_HANDLE_IS_VALID(handle)` for typed handles.

## API Reference

Nim language-server hover and completion information is available directly
from the `##` comments on every public call. The comments describe parameter
directions, returns, ownership and threading requirements, remarks, and
warnings where upstream specifies them.

Build the browsable HTML reference with:

```sh
tools/build_api_docs.sh
```

The same responsive documentation site is published through GitHub Pages at
[puffball1567.github.io/bgfxim](https://puffball1567.github.io/bgfxim/).

See [docs/API_REFERENCE.md](docs/API_REFERENCE.md) for editor usage,
custom output locations, and documentation-source details.

## Demos

### Visible SDL3/OpenGL triangle

On Linux with SDL3 installed, the visible demo opens a resizable window and
submits a colored triangle through the real bgfx OpenGL renderer:

```sh
examples/run_sdl_demo.sh <path-to-bgfx> <path-to-bx> <path-to-bimg>
```

The helper performs a clean temporary native build, so the first launch takes
longer than an ordinary incremental application build. It loads the
`vs_cubes.bin` and `fs_cubes.bin` OpenGL shader binaries shipped in the
supplied bgfx tree. Close the window or press Escape to stop it. SDL handles
only window creation and events; platform data, vertex/index buffers, shaders,
the program, submission, frames, resize handling, and shutdown go through this
binding.

Pass a frame count to run the same demo non-interactively. CI uses three
frames under Xvfb and Mesa software rendering:

```sh
examples/run_sdl_demo.sh \
  <path-to-bgfx> <path-to-bx> <path-to-bimg> 3
```

See [examples/README.md](examples/README.md) for the exact pipeline and native
dependency responsibilities.

### Headless integration demos

These demos build a temporary NOOP-only bgfx and need no display or graphics
device:

```sh
examples/run_noop_demos.sh <path-to-bgfx> <path-to-bx> <path-to-bimg>
```

`noop_basic.nim` covers initialization, capabilities, views, frames, and
shutdown. `noop_resources.nim` covers vertex layouts, copied memory, typed
handles, vertex/index buffers, textures, uniforms, and an encoder.
`noop_validation.nim` covers API-version rejection, count-only queries,
conflicting texture flags, unsupported video decoding, excessive array layers,
and invalid framebuffer attachments through bgfx's non-fatal validation APIs.

## Verification

The verification checks cover complementary failure modes:

| Check | Coverage |
| --- | --- |
| `tests/test_api.nim` | Representative declarations, callback slots, helpers, aliases, and compile-time values |
| `tests/test_abi.nim` | Size and alignment of all 43 complete types plus offsets of all 443 fields, including 215 interface-vtable slots |
| `tests/test_values.nim` | Direct C/Nim comparison of 334 constants, 458 enum values, and all 17 state helpers |
| `tests/test_runtime.nim` | Executed Nim/C FFI calls, values, pointers, varargs, aliases, and ordering |
| `tests/test_errors.nim` | Executed null, rejected-init, version mismatch, boundary flags, allocation failure, callback, invalid-handle, and validation-error paths |
| `tests/test_generators.py` | Missing and duplicate API elements and undocumented parameters must be rejected; documentation and test output must remain deterministic |
| All-signatures compile test | C compilation of calls to all 216 functions |
| NOOP demos | Real initialization, resource/encoder lifecycle, and safe validation failures on Linux and macOS |
| SDL3/OpenGL triangle | Real native-window handoff, buffers, shaders, program, submit, frames, and ordered destruction |

`tests/run_validation.sh` runs the compile, ABI, value, normal/error FFI,
generator rejection, and all-signatures checks against supplied bgfx and bx
trees. CI first reproduces the checked-in declarations and exhaustive test
sources, then runs that suite through the platform matrix and executes all
three real NOOP demos against the pinned upstream revisions. The dedicated
renderer job also executes the SDL3/OpenGL triangle for a fixed frame count.

## Updating the Binding

Generate from bgfx's generated headers, then review and run the complete
verification suite:

```sh
python3 tools/generate_defines.py \
  <path-to-bgfx>/include/bgfx/defines.h bgfx/defines.nim
python3 tools/update_bindings.py \
  <path-to-bgfx>/include/bgfx/c99/bgfx.h bgfx.nim
python3 tools/generate_signature_test.py \
  <path-to-bgfx>/include/bgfx/c99/bgfx.h <output-test.nim>
python3 tools/generate_abi_test.py bgfx.nim tests/test_abi.nim
python3 tools/generate_value_test.py \
  bgfx.nim bgfx/defines.nim tests/test_values.nim
tests/run_validation.sh <path-to-bgfx> <path-to-bx>
```

An upstream update must change the recorded revision, API version, generated
files, API comments, tests, and third-party notice together.

## Current Boundaries

Version 0.4.0 remains a low-level binding.

- The OpenGL renderer smoke test runs on Linux x86_64 with Mesa software
  rendering; it verifies successful submission and cleanup, not pixel output
  or physical GPU-driver behavior. macOS coverage currently uses NOOP.
- Windows coverage executes the synthetic FFI suite but does not yet build and
  run a real bgfx renderer.
- CI targets Nim's C backend. The C++20 check verifies type layout and values
  against the native headers, but full Nim C++-backend compatibility is not
  currently claimed.
- Direct3D, Metal, Vulkan, OpenGL ES, WebGPU, mobile, and WebAssembly runtime
  paths still need platform-specific validation.
- Basic shader/program submission now has real OpenGL coverage. Compute,
  framebuffer, screenshot, video, and custom allocator/callback behavior have
  compile coverage but incomplete real runtime coverage.
- Calls that bgfx documents as fatal, asserted, or undefined precondition
  violations are intentionally not sent to the real library; equivalent ABI
  failure paths are exercised with the C stub instead.
- bgfxim does not build native dependencies automatically for applications and
  does not provide a high-level renderer, window framework, or shader pipeline.
- The binding follows one pinned bgfx revision; mixing headers and libraries
  from another revision is unsupported.

## Contributing

Development and release branches follow the same protected `devel` → `main`
workflow used by Clay Board Style System. See [CONTRIBUTING.md](CONTRIBUTING.md)
for update and verification requirements. Suspected vulnerabilities should be
reported as described in [SECURITY.md](SECURITY.md).

## License and Acknowledgements

bgfxim is available under the [BSD 2-Clause License](LICENSE). The bindings are
derived from and interface with bgfx, bx, and bimg. Their copyright and license
text, together with the optional SDL3 notice, are reproduced in
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Every demo prints a concise
runtime notice.
