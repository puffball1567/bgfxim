# SPDX-License-Identifier: BSD-2-Clause
# bgfx is Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause.
# See ../LICENSE and ../THIRD_PARTY_NOTICES.md.

import bgfx

type Position = object
  x, y, z: cfloat

proc showLicenseNotice() =
  echo "bgfxim: BSD-2-Clause"
  echo "bgfx: Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause"

showLicenseNotice()

var init: bgfx_init_t
BGFX.initCtor(addr init)
init.type = BGFX_RENDERER_TYPE_NOOP
init.swapChain.width = 64
init.swapChain.height = 64

if not BGFX.init(addr init):
  raise newException(IOError, "bgfx NOOP initialization failed")

try:
  var layout: bgfx_vertex_layout_t
  discard BGFX.vertexLayoutBegin(addr layout, BGFX_RENDERER_TYPE_NOOP)
  discard BGFX.vertexLayoutAdd(
    addr layout, BGFX_ATTRIB_POSITION, 3, BGFX_ATTRIB_TYPE_FLOAT, false, false)
  BGFX.vertexLayoutEnd(addr layout)
  doAssert layout.stride == uint16(sizeof(Position))

  var vertices = [
    Position(x: -1.0, y: -1.0, z: 0.0),
    Position(x: 1.0, y: -1.0, z: 0.0),
    Position(x: 0.0, y: 1.0, z: 0.0),
  ]
  var indices = [0'u16, 1'u16, 2'u16]

  let vertexMem = BGFX.copy(addr vertices[0], uint32(sizeof(vertices)))
  let indexMem = BGFX.copy(addr indices[0], uint32(sizeof(indices)))
  doAssert vertexMem != nil and vertexMem.size == uint32(sizeof(vertices))
  doAssert indexMem != nil and indexMem.size == uint32(sizeof(indices))

  let vertexBuffer = BGFX.createVertexBuffer(vertexMem, addr layout, BGFX_BUFFER_NONE)
  let indexBuffer = BGFX.createIndexBuffer(indexMem, BGFX_BUFFER_NONE)
  doAssert BGFX_HANDLE_IS_VALID(vertexBuffer)
  doAssert BGFX_HANDLE_IS_VALID(indexBuffer)
  BGFX.setVertexBufferName(vertexBuffer, "demo vertices", 13)
  BGFX.setIndexBufferName(indexBuffer, "demo indices", 12)

  doAssert BGFX.isTextureValid(
    1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8, BGFX_TEXTURE_NONE)
  var textureInfo: bgfx_texture_info_t
  BGFX.calcTextureSize(
    addr textureInfo, 1, 1, 1, false, false, 1, BGFX_TEXTURE_FORMAT_RGBA8)
  doAssert textureInfo.storageSize == 4

  var pixel = [0x40'u8, 0x80'u8, 0xc0'u8, 0xff'u8]
  let textureMem = BGFX.copy(addr pixel[0], uint32(sizeof(pixel)))
  let texture = BGFX.createTexture2D(
    1, 1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8,
    BGFX_TEXTURE_NONE, textureMem, 0)
  doAssert BGFX_HANDLE_IS_VALID(texture)
  BGFX.setTextureName(texture, "demo texture", 12)

  let uniform = BGFX.createUniform("u_demoColor", BGFX_UNIFORM_TYPE_VEC4, 1)
  doAssert BGFX_HANDLE_IS_VALID(uniform)
  var uniformInfo: bgfx_uniform_info_t
  BGFX.getUniformInfo(uniform, addr uniformInfo)
  doAssert uniformInfo.type == BGFX_UNIFORM_TYPE_VEC4
  doAssert uniformInfo.num == 1

  let encoder = BGFX.encoderBegin(true)
  doAssert encoder != nil
  BGFX.encoderSetMarker(encoder, "Nim encoder", 11)
  discard BGFX.encoderSetScissor(encoder, 0, 0, 32, 32)
  BGFX.encoderTouch(encoder, 1)
  BGFX.encoderEnd(encoder)

  discard BGFX.frame(BGFX_FRAME_NONE)

  BGFX.destroyUniform(uniform)
  BGFX.destroyTexture(texture)
  BGFX.destroyIndexBuffer(indexBuffer)
  BGFX.destroyVertexBuffer(vertexBuffer)
  discard BGFX.frame(BGFX_FRAME_NONE)

  echo "layout/memory/handles/texture/uniform/encoder calls passed"
finally:
  BGFX.shutdown()
