# SPDX-License-Identifier: BSD-2-Clause

{.compile: "api166_stub.c".}
import bgfx

proc validated(): bool {.importc: "bgfxim_test_api166_validated", cdecl.}
proc uniformRef(): pointer {.importc: "bgfxim_test_uniform_ref", cdecl.}
proc interfaceTable(): ptr bgfx_interface_vtbl_t
  {.importc: "bgfxim_test_api166_interface", cdecl.}

let encoder = cast[ptr bgfx_encoder_t](0x4560'u)
let view = high(uint16)
BGFX.setViewRect(view, -2, -3, 640, 480, 0.25, 0.75)
BGFX.setViewDepthBias(view, -7, 1.25, -1.0)
BGFX.setViewSampleMask(view, 0x80000001'u32)
BGFX.setSampleMask(high(uint32))
BGFX.encoderSetSampleMask(encoder, 0x80000001'u32)
let depthCache = BGFX.setDepthControl(-7, 1.25, -1.0, true)
let encoderDepthCache = BGFX.encoderSetDepthControl(encoder, -7, 1.25, -1.0, false)
doAssert depthCache == 0xabcd'u16
doAssert encoderDepthCache == 0xdef0'u16
BGFX.setDepthControlCached(depthCache)
BGFX.encoderSetDepthControlCached(encoder, encoderDepthCache)

let uniform = bgfx_uniform_handle_t(idx: 17)
var values: array[8, cfloat]
BGFX.setUniformRef(uniform, addr values[0], 2)
doAssert uniformRef() == addr values[0]
BGFX.encoderSetUniformRef(encoder, uniform, addr values[0], 2)

let texture = bgfx_texture_handle_t(idx: 23)
BGFX.setTextureView(high(uint8), uniform, texture, 257, 513, 3, 5,
  high(uint32), 7, high(uint8))
BGFX.encoderSetTextureView(encoder, high(uint8), uniform, texture, 257, 513, 3, 5,
  high(uint32), 7, high(uint8))

let indexBuffer = bgfx_index_buffer_handle_t(idx: high(uint16) - 1)
let vertexBuffer = bgfx_vertex_buffer_handle_t(idx: high(uint16) - 1)
let dynamicIndexBuffer = bgfx_dynamic_index_buffer_handle_t(idx: high(uint16) - 1)
let dynamicVertexBuffer = bgfx_dynamic_vertex_buffer_handle_t(idx: high(uint16) - 1)
BGFX.setComputeIndexBuffer(high(uint8), indexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))
BGFX.encoderSetComputeIndexBuffer(encoder, high(uint8), indexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))
BGFX.setComputeVertexBuffer(high(uint8), vertexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))
BGFX.encoderSetComputeVertexBuffer(encoder, high(uint8), vertexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))
BGFX.setComputeDynamicIndexBuffer(high(uint8), dynamicIndexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))
BGFX.encoderSetComputeDynamicIndexBuffer(encoder, high(uint8), dynamicIndexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))
BGFX.setComputeDynamicVertexBuffer(high(uint8), dynamicVertexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))
BGFX.encoderSetComputeDynamicVertexBuffer(encoder, high(uint8), dynamicVertexBuffer, BGFX_ACCESS_READWRITE, 0xffffff00'u32, high(uint32))

var attachment: bgfx_attachment_t
let attachmentFlags = BGFX_ATTACHMENT_READ_ONLY_DEPTH or BGFX_ATTACHMENT_SRGB
BGFX.attachmentInit(addr attachment, texture, BGFX_ACCESS_READ, 257, 513, 7, attachmentFlags)
doAssert attachment.handle.idx == texture.idx
doAssert attachment.access == BGFX_ACCESS_READ
doAssert attachment.layer == 257 and attachment.numLayers == 513
doAssert attachment.mip == 7 and attachment.flags == attachmentFlags

# Call C-populated vtable slots after insertion of the new API 166 entries.
let api = interfaceTable()
api.set_uniform_ref(uniform, addr values[0], 2)
doAssert uniformRef() == addr values[0]
doAssert api.encoder_set_depth_control(encoder, -7, 1.25, -1.0, false) == 0xdef0'u16
doAssert validated()
echo "API 166 argument and interface FFI calls passed"
