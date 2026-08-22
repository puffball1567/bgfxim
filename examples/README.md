# bgfxim examples

The examples stay close to bgfx's C99 API. They demonstrate native setup and
resource ownership without adding a renderer framework, asset pipeline, or
automatic lifetime layer.

All helpers build into a temporary directory and print the applicable bgfxim,
bgfx, bx, bimg, and SDL license notices at startup. The supplied bgfx, bx, and
bimg trees must match each other. The revisions used by CI are recorded in the
top-level [README](../README.md) and [third-party notices](../THIRD_PARTY_NOTICES.md).

## SDL3/OpenGL triangle

Requirements on Linux:

- Nim 2.0 or newer;
- a C++20 compiler and archiver;
- SDL3 development files discoverable as `sdl3` through `pkg-config`;
- X11 or Wayland and an OpenGL 4.3 implementation;
- bgfx, bx, and bimg source trees.

Run until the window is closed or Escape is pressed:

```sh
examples/run_sdl_demo.sh <bgfx-dir> <bx-dir> <bimg-dir>
```

Pass a fourth argument for deterministic automation:

```sh
examples/run_sdl_demo.sh <bgfx-dir> <bx-dir> <bimg-dir> 3
```

The demo deliberately performs the low-level sequence an application must
own:

1. SDL3 creates a window and exposes its X11 or Wayland native handles.
2. Those handles are copied into `bgfx_platform_data_t` before OpenGL
   initialization.
3. A position/color layout and static vertex/index buffers are created.
4. The OpenGL `vs_cubes.bin` and `fs_cubes.bin` files from the supplied bgfx
   tree are copied into shader handles and linked into a program.
5. Each frame sets the view, buffers, and state, submits one triangle, and
   advances bgfx.
6. The program and buffers are destroyed before the final frame and shutdown.

CI runs this path under Xvfb with Mesa software rendering. It asserts renderer
selection, valid resource handles, the requested number of submitted frames,
and clean process termination. It intentionally does not compare pixels or
claim physical GPU-driver correctness; those belong to bgfx and the renderer
implementation.

## NOOP integration

The NOOP demos require no window or graphics device:

```sh
examples/run_noop_demos.sh <bgfx-dir> <bx-dir> <bimg-dir>
```

- `noop_basic.nim` covers initialization, capabilities, views, frames, and
  shutdown.
- `noop_resources.nim` covers layouts, copied memory, buffers, textures,
  uniforms, encoders, and ordered destruction.
- `noop_validation.nim` covers documented non-fatal validation and negotiation
  failures.

The helpers compile the pinned native sources for verification convenience.
Applications remain responsible for selecting, building, and distributing
their own native bgfx configuration.
