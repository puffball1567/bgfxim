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

- **Complete C99 surface.** All 208 functions, public structs, enums, callback
  and interface vtables, 350 object-like constants, and 17 state helpers are
  available.
- **Auditable ABI.** Imported objects use the C typedef names from bgfx's
  generated header, and the test suite compares every public struct size with
  the C compiler.
- **Mechanical updates.** Checked-in generators update declarations and
  constants from upstream generated headers instead of relying on manual
  transcription.
- **Real execution coverage.** Tests cross the Nim/C boundary, initialize the
  real NOOP renderer, exercise resource and encoder paths, and open an SDL3
  window through the OpenGL backend.
- **Thin by design.** The binding preserves bgfx ownership and threading rules;
  higher-level rendering APIs can be built independently.

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

Version `0.1.0` targets bgfx API version 155 at revision
`d8db55f8123a4a0871b1290fec2e5d0caae01bbf`.

The release has been exercised with:

- Nim 2.2.10 on Linux x86_64;
- bx revision `9e3fadf6f11380031486be704d2ff46ca143664f`;
- bimg revision `371d90098b1fd017cd00205979d5ef74b8c3ed62`;
- the real bgfx NOOP and OpenGL 4.3 renderers;
- SDL 3.3.0 with X11 native-window integration.

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
nimble install https://github.com/puffball1567/bgfxim@#v0.1.0
```

The repository contains the source bindings, generators, documentation, tests,
and examples. The installed package does not bundle native bgfx, bx, bimg, or
SDL binaries.

### 3. Initialize bgfx

```nim
import bgfx

var init: bgfx_init_t
BGFX.initCtor(addr init)
init.resolution.width = 1280
init.resolution.height = 720
init.resolution.reset = BGFX_RESET_VSYNC

if not BGFX.init(addr init):
  raise newException(IOError, "bgfx initialization failed")

try:
  BGFX.setDebug(BGFX_DEBUG_TEXT)
  BGFX.touch(0)
  discard BGFX.frame(BGFX_FRAME_NONE)
finally:
  BGFX.shutdown()
```

Platform applications must populate `init.platformData` with the native window
and display handles before initialization. The SDL3 demo contains a compact
X11/Wayland example.

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

## Demos

### Visible SDL3/OpenGL demo

On Linux with SDL3 installed, the visible demo opens a resizable window and
animates its clear color through the real bgfx OpenGL renderer:

```sh
examples/run_sdl_demo.sh <path-to-bgfx> <path-to-bx> <path-to-bimg>
```

The helper performs a clean temporary native build, so the first launch takes
longer than an ordinary incremental application build. Close the window or
press Escape to stop it. SDL handles only window creation and events; platform
data, resize handling, views, frames, and shutdown go through this binding.

### Headless integration demos

These demos build a temporary NOOP-only bgfx and need no display or graphics
device:

```sh
examples/run_noop_demos.sh <path-to-bgfx> <path-to-bx> <path-to-bimg>
```

`noop_basic.nim` covers initialization, capabilities, views, frames, and
shutdown. `noop_resources.nim` covers vertex layouts, copied memory, typed
handles, vertex/index buffers, textures, uniforms, and an encoder.

## Verification

The release checks cover complementary failure modes:

| Check | Coverage |
| --- | --- |
| `tests/test_api.nim` | Compile-time constants plus C/Nim struct-size ABI assertions |
| `tests/test_runtime.nim` | Executed Nim/C FFI calls, values, pointers, varargs, aliases, and ordering |
| Generated signature test | C compilation of calls to all 208 functions |
| NOOP demos | Real bgfx initialization and resource/encoder lifecycle |
| SDL3 demo | Real native-window handoff and OpenGL frame execution |

CI regenerates checked-in declarations, runs the API and runtime tests,
compiles every function signature, and executes both real NOOP demos against
the pinned upstream revisions.

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
```

An upstream update must change the recorded revision, API version, generated
files, tests, and third-party notice together.

## Current Boundaries

Version 0.1.0 is a low-level developer release.

- Linux x86_64 is the only platform exercised with a real renderer so far.
- Direct3D, Metal, Vulkan, OpenGL ES, WebGPU, mobile, and WebAssembly runtime
  paths still need platform-specific validation.
- Shader/program submission, compute, framebuffer, screenshot, video, and
  custom allocator/callback behavior have compile coverage but incomplete real
  runtime coverage.
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
