# SPDX-License-Identifier: BSD-2-Clause
# bgfx is Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause.
# SDL 3 is used under the zlib License.
# See ../LICENSE and ../THIRD_PARTY_NOTICES.md.

{.compile: "sdl_window.c".}

import std/[math, os, strutils]
import bgfx

proc createWindow(title: cstring; width, height: cint): pointer
  {.importc: "bgfxim_sdl_create_window", cdecl.}
proc sdlError(): cstring {.importc: "bgfxim_sdl_error", cdecl.}
proc getPlatformData(window: pointer; ndt, nwh: ptr pointer;
    nativeWindowType: ptr cint): cint
  {.importc: "bgfxim_sdl_get_platform_data", cdecl.}
proc pollWindow(window: pointer; width, height: ptr cint): cint
  {.importc: "bgfxim_sdl_poll_window", cdecl.}
proc delay(milliseconds: uint32) {.importc: "bgfxim_sdl_delay", cdecl.}
proc destroyWindow(window: pointer)
  {.importc: "bgfxim_sdl_destroy_window", cdecl.}

proc clearColor(frame: int): uint32 =
  let phase = float(frame) * 0.025
  let red = uint32(48.0 + 96.0 * (sin(phase) + 1.0) * 0.5)
  let green = uint32(48.0 + 96.0 * (sin(phase + 2.094) + 1.0) * 0.5)
  let blue = uint32(96.0 + 128.0 * (sin(phase + 4.188) + 1.0) * 0.5)
  (red shl 24) or (green shl 16) or (blue shl 8) or 0xff'u32

echo "bgfxim: BSD-2-Clause"
echo "bgfx: Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause"
echo "SDL 3: zlib License (see THIRD_PARTY_NOTICES.md)"

let maxFrames = if paramCount() == 0: 0 else: parseInt(paramStr(1))
let window = createWindow("bgfxim - real bgfx OpenGL demo", 960, 540)
if window == nil:
  raise newException(IOError, "SDL window creation failed: " & $sdlError())

var platformData: bgfx_platform_data_t
var nativeWindowType: cint
if getPlatformData(window, addr platformData.ndt, addr platformData.nwh,
    addr nativeWindowType) == 0:
  let message = $sdlError()
  destroyWindow(window)
  raise newException(IOError, "native window lookup failed: " & message)
platformData.type = bgfx_native_window_handle_type_t(nativeWindowType)

var init: bgfx_init_t
BGFX.initCtor(addr init)
init.type = BGFX_RENDERER_TYPE_OPENGL
init.platformData = platformData
init.resolution.width = 960
init.resolution.height = 540
init.resolution.reset = BGFX_RESET_VSYNC

if not BGFX.init(addr init):
  destroyWindow(window)
  raise newException(IOError, "bgfx OpenGL initialization failed")

try:
  echo "renderer: ", $BGFX.getRendererName(BGFX.getRendererType())
  echo "Close the window or press Escape to exit."

  var width = 960.cint
  var height = 540.cint
  var previousWidth = width
  var previousHeight = height
  var frame = 0

  while pollWindow(window, addr width, addr height) != 0 and
      (maxFrames == 0 or frame < maxFrames):
    if width != previousWidth or height != previousHeight:
      BGFX.reset(uint32(width), uint32(height), BGFX_RESET_VSYNC,
        BGFX_TEXTURE_FORMAT_COUNT)
      previousWidth = width
      previousHeight = height

    BGFX.setViewRect(0, 0, 0, uint16(width), uint16(height))
    BGFX.setViewClear(0, BGFX_CLEAR_COLOR, clearColor(frame), 1.0, 0)
    BGFX.touch(0)
    discard BGFX.frame(BGFX_FRAME_NONE)
    delay(16)
    inc frame

  echo "visible OpenGL frames passed: ", frame
finally:
  BGFX.shutdown()
  destroyWindow(window)
