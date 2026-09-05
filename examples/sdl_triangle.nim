# SPDX-License-Identifier: BSD-2-Clause
# bgfx is Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause.
# SDL 3 is used under the zlib License.
# See ../LICENSE and ../THIRD_PARTY_NOTICES.md.

{.compile: "sdl_window.c".}

import std/[math, os, strutils]
import bgfx

type PositionColorVertex = object
  x, y, z: cfloat
  abgr: uint32

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
  let red = uint32(24.0 + 48.0 * (sin(phase) + 1.0) * 0.5)
  let green = uint32(24.0 + 48.0 * (sin(phase + 2.094) + 1.0) * 0.5)
  let blue = uint32(48.0 + 64.0 * (sin(phase + 4.188) + 1.0) * 0.5)
  (red shl 24) or (green shl 16) or (blue shl 8) or 0xff'u32

proc loadShader(path, label: string): bgfx_shader_handle_t =
  let shaderBytes = readFile(path)
  if shaderBytes.len == 0 or uint64(shaderBytes.len) > uint64(high(uint32)):
    raise newException(IOError, "invalid shader binary: " & path)

  let memory = BGFX.copy(unsafeAddr shaderBytes[0], uint32(shaderBytes.len))
  if memory == nil:
    raise newException(IOError, "bgfx could not copy shader binary: " & path)

  result = BGFX.createShader(memory)
  if not BGFX_HANDLE_IS_VALID(result):
    raise newException(IOError, "bgfx could not create shader: " & path)
  BGFX.setShaderName(result, label.cstring, int32(label.len))

echo "bgfxim: BSD-2-Clause"
echo "bgfx: Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause"
echo "SDL 3: zlib License (see THIRD_PARTY_NOTICES.md)"

if paramCount() != 2:
  raise newException(ValueError,
    "usage: sdl-triangle <frames; 0 until closed> <OpenGL shader directory>")

let maxFrames = parseInt(paramStr(1))
if maxFrames < 0:
  raise newException(ValueError, "frame count must be non-negative")
let shaderDirectory = paramStr(2)

let window = createWindow("bgfxim - real bgfx OpenGL triangle", 960, 540)
if window == nil:
  raise newException(IOError, "SDL window creation failed: " & $sdlError())

var bgfxInitialized = false
var vertexBuffer = invalidHandle(bgfx_vertex_buffer_handle_t)
var indexBuffer = invalidHandle(bgfx_index_buffer_handle_t)
var vertexShader = invalidHandle(bgfx_shader_handle_t)
var fragmentShader = invalidHandle(bgfx_shader_handle_t)
var program = invalidHandle(bgfx_program_handle_t)

try:
  var swapChain: bgfx_swap_chain_t
  var nativeWindowType: cint
  if getPlatformData(window, addr swapChain.ndt, addr swapChain.nwh,
      addr nativeWindowType) == 0:
    raise newException(IOError, "native window lookup failed: " & $sdlError())

  var init: bgfx_init_t
  BGFX.initCtor(addr init)
  init.type = BGFX_RENDERER_TYPE_OPENGL
  init.platformData.type = bgfx_native_window_handle_type_t(nativeWindowType)
  swapChain.width = 960
  swapChain.height = 540
  init.swapChain = swapChain
  init.reset = BGFX_RESET_VSYNC

  if not BGFX.init(addr init):
    raise newException(IOError, "bgfx OpenGL initialization failed")
  bgfxInitialized = true

  if BGFX.getRendererType() != BGFX_RENDERER_TYPE_OPENGL:
    raise newException(IOError, "bgfx selected an unexpected renderer")
  echo "renderer: ", $BGFX.getRendererName(BGFX.getRendererType())

  var layout: bgfx_vertex_layout_t
  discard BGFX.vertexLayoutBegin(addr layout, BGFX_RENDERER_TYPE_OPENGL)
  discard BGFX.vertexLayoutAdd(
    addr layout, BGFX_ATTRIB_POSITION, 3, BGFX_ATTRIB_TYPE_FLOAT, false, false)
  discard BGFX.vertexLayoutAdd(
    addr layout, BGFX_ATTRIB_COLOR0, 4, BGFX_ATTRIB_TYPE_UINT8, true, false)
  BGFX.vertexLayoutEnd(addr layout)
  doAssert layout.stride == uint16(sizeof(PositionColorVertex))

  var vertices = [
    PositionColorVertex(x: 0.0, y: 0.65, z: 0.0, abgr: 0xff4040ff'u32),
    PositionColorVertex(x: -0.65, y: -0.55, z: 0.0, abgr: 0xff40ff40'u32),
    PositionColorVertex(x: 0.65, y: -0.55, z: 0.0, abgr: 0xffff4040'u32),
  ]
  var indices = [0'u16, 1'u16, 2'u16]

  let vertexMemory = BGFX.copy(addr vertices[0], uint32(sizeof(vertices)))
  if vertexMemory == nil:
    raise newException(IOError, "bgfx vertex memory allocation failed")
  vertexBuffer = BGFX.createVertexBuffer(vertexMemory, addr layout,
    BGFX_BUFFER_NONE)
  if not BGFX_HANDLE_IS_VALID(vertexBuffer):
    raise newException(IOError, "bgfx vertex buffer creation failed")

  let indexMemory = BGFX.copy(addr indices[0], uint32(sizeof(indices)))
  if indexMemory == nil:
    raise newException(IOError, "bgfx index memory allocation failed")
  indexBuffer = BGFX.createIndexBuffer(indexMemory, BGFX_BUFFER_NONE)
  if not BGFX_HANDLE_IS_VALID(indexBuffer):
    raise newException(IOError, "bgfx index buffer creation failed")
  BGFX.setVertexBufferName(vertexBuffer, "triangle vertices", 17)
  BGFX.setIndexBufferName(indexBuffer, "triangle indices", 16)

  vertexShader = loadShader(
    shaderDirectory / "vs_cubes.bin", "triangle vertex shader")
  fragmentShader = loadShader(
    shaderDirectory / "fs_cubes.bin", "triangle fragment shader")
  program = BGFX.createProgram(vertexShader, fragmentShader, false)
  if not BGFX_HANDLE_IS_VALID(program):
    raise newException(IOError, "bgfx program creation failed")
  BGFX.destroyShader(vertexShader)
  vertexShader = invalidHandle(bgfx_shader_handle_t)
  BGFX.destroyShader(fragmentShader)
  fragmentShader = invalidHandle(bgfx_shader_handle_t)

  echo "Close the window or press Escape to exit."
  var width = 960.cint
  var height = 540.cint
  var previousWidth = width
  var previousHeight = height
  var frame = 0

  while pollWindow(window, addr width, addr height) != 0 and
      (maxFrames == 0 or frame < maxFrames):
    if width != previousWidth or height != previousHeight:
      swapChain.width = uint32(width)
      swapChain.height = uint32(height)
      BGFX.reset(BGFX_RESET_VSYNC, addr swapChain)
      previousWidth = width
      previousHeight = height

    BGFX.setViewRect(0, 0, 0, uint16(width), uint16(height))
    BGFX.setViewClear(0, BGFX_CLEAR_COLOR, clearColor(frame), 1.0, 0)
    BGFX.setVertexBuffer(0, vertexBuffer, 0, uint32(vertices.len))
    BGFX.setIndexBuffer(indexBuffer, 0, uint32(indices.len))
    BGFX.setState(BGFX_STATE_WRITE_RGB or BGFX_STATE_WRITE_A, 0)
    BGFX.submit(0, program, 0, BGFX_DISCARD_ALL)
    discard BGFX.frame(BGFX_FRAME_NONE)
    delay(16)
    inc frame

  if maxFrames > 0 and frame != maxFrames:
    raise newException(IOError, "window closed before the requested frames ran")
  echo "OpenGL renderer smoke passed: ", frame, " submitted frames"
finally:
  if bgfxInitialized:
    if BGFX_HANDLE_IS_VALID(program):
      BGFX.destroyProgram(program)
    if BGFX_HANDLE_IS_VALID(vertexShader):
      BGFX.destroyShader(vertexShader)
    if BGFX_HANDLE_IS_VALID(fragmentShader):
      BGFX.destroyShader(fragmentShader)
    if BGFX_HANDLE_IS_VALID(indexBuffer):
      BGFX.destroyIndexBuffer(indexBuffer)
    if BGFX_HANDLE_IS_VALID(vertexBuffer):
      BGFX.destroyVertexBuffer(vertexBuffer)
    discard BGFX.frame(BGFX_FRAME_NONE)
    BGFX.shutdown()
  destroyWindow(window)
