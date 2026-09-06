# SPDX-License-Identifier: BSD-2-Clause

{.compile: "runtime_stub.c".}

import bgfx

proc testInitValidated(): bool {.importc: "bgfxim_test_init_validated", cdecl.}
proc testShutdownCalled(): bool {.importc: "bgfxim_test_shutdown_called", cdecl.}
proc testVarargsValidated(): bool {.importc: "bgfxim_test_varargs_validated", cdecl.}
proc testDebugFlags(): uint32 {.importc: "bgfxim_test_debug_flags", cdecl.}
proc testDebugHandle(): uint16 {.importc: "bgfxim_test_debug_handle", cdecl.}
proc testDebugScale(): uint8 {.importc: "bgfxim_test_debug_scale", cdecl.}
proc testFrameFlags(): uint8 {.importc: "bgfxim_test_frame_flags", cdecl.}

let texture = bgfx_texture_handle_t(idx: 17'u16)
var textureRegion: bgfx_texture_region_t
BGFX.textureRegionInit(addr textureRegion, texture, 3'u16, 5'u16, 64'u16,
  32'u16)
doAssert textureRegion.handle.idx == texture.idx
doAssert textureRegion.mip == 0'u8
doAssert textureRegion.x == 3'u16 and textureRegion.y == 5'u16
doAssert textureRegion.z == 0'u16
doAssert textureRegion.width == 64'u16 and textureRegion.height == 32'u16
doAssert textureRegion.depth == 0'u16

let buffer = bgfx_buffer_handle_t(
  idx: 23'u16,
  `type`: uint16(BGFX_BUFFER_HANDLE_TYPE_VERTEX_BUFFER))
var bufferRegion: bgfx_buffer_region_t
BGFX.bufferRegionInitBuffer(addr bufferRegion, buffer, 128'u32, 4096'u32)
doAssert bufferRegion.handle.idx == buffer.idx
doAssert bufferRegion.handle.`type` == buffer.`type`
doAssert bufferRegion.offset == 128'u32 and bufferRegion.size == 4096'u32
doAssert bufferRegion.rowPitch == 0'u32 and bufferRegion.slicePitch == 0'u32

var init: bgfx_init_t
BGFX.initCtor(addr init)
doAssert init.type == BGFX_RENDERER_TYPE_NOOP
doAssert init.vendorId == 0x1234'u16
doAssert init.swapChain.width == 640'u32
doAssert init.swapChain.height == 480'u32
doAssert BGFX.init(addr init)
doAssert testInitValidated()

let debugTarget = bgfx_frame_buffer_handle_t(idx: 37'u16)
BGFX.setDebug(BGFX_DEBUG_TEXT or BGFX_DEBUG_STATS, debugTarget, 2'u8)
doAssert testDebugFlags() == (BGFX_DEBUG_TEXT or BGFX_DEBUG_STATS)
doAssert testDebugHandle() == debugTarget.idx
doAssert testDebugScale() == 2'u8

BGFX.dbgTextPrintf(7'u16, 9'u16, 0x1f'u8, "%d", 42)
doAssert testVarargsValidated()

var layout: bgfx_vertex_layout_t
doAssert BGFX.vertexLayoutBegin(addr layout, BGFX_RENDERER_TYPE_NOOP) ==
  addr layout
doAssert layout.hash == 0xabcdef01'u32
doAssert BGFX.vertexLayoutAdd(addr layout, BGFX_ATTRIB_POSITION, 3'u8,
  BGFX_ATTRIB_TYPE_FLOAT, false, false) == addr layout
doAssert layout.stride == 12'u16
BGFX.vertexLayoutEnd(addr layout)
doAssert layout.hash == 0x543210fe'u32

var renderers: array[1, bgfx_renderer_type_t]
doAssert BGFX.getSupportedRenderers(1'u8, addr renderers[0]) == 1'u8
doAssert renderers[0] == BGFX_RENDERER_TYPE_NOOP
doAssert BGFX.getRendererType() == BGFX_RENDERER_TYPE_NOOP
doAssert $BGFX.getRendererName(BGFX_RENDERER_TYPE_NOOP) == "StubRenderer"

let caps = BGFX.getCaps()
doAssert caps != nil
doAssert caps.vendorId == 0xbeef'u16
doAssert caps.limits.maxDrawCalls == 321'u32
doAssert BGFX.bgfx_get_caps() == caps

doAssert cast[uint](BGFX.getInterface(BGFX_API_VERSION)) == 0x1230'u
doAssert BGFX.frame(BGFX_FRAME_FLUSH) == 0x12345678'u32
doAssert testFrameFlags() == BGFX_FRAME_FLUSH

BGFX.shutdown()
doAssert testShutdownCalled()

echo "runtime FFI calls passed"
