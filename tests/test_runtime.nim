# SPDX-License-Identifier: BSD-2-Clause

{.compile: "runtime_stub.c".}

import bgfx

proc testInitValidated(): bool {.importc: "bgfxim_test_init_validated", cdecl.}
proc testShutdownCalled(): bool {.importc: "bgfxim_test_shutdown_called", cdecl.}
proc testVarargsValidated(): bool {.importc: "bgfxim_test_varargs_validated", cdecl.}
proc testDebugFlags(): uint32 {.importc: "bgfxim_test_debug_flags", cdecl.}
proc testFrameFlags(): uint8 {.importc: "bgfxim_test_frame_flags", cdecl.}

var init: bgfx_init_t
BGFX.initCtor(addr init)
doAssert init.type == BGFX_RENDERER_TYPE_NOOP
doAssert init.vendorId == 0x1234'u16
doAssert init.resolution.width == 640'u32
doAssert init.resolution.height == 480'u32
doAssert BGFX.init(addr init)
doAssert testInitValidated()

BGFX.setDebug(BGFX_DEBUG_TEXT or BGFX_DEBUG_STATS)
doAssert testDebugFlags() == (BGFX_DEBUG_TEXT or BGFX_DEBUG_STATS)

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
