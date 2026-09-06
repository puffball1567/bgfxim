# SPDX-License-Identifier: BSD-2-Clause
# bgfx is Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause.
# See ../LICENSE and ../THIRD_PARTY_NOTICES.md.

import bgfx

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
  let caps = BGFX.getCaps()
  doAssert caps != nil

  # API version negotiation has a documented null failure result.
  doAssert BGFX.getInterface(BGFX_API_VERSION) != nil
  doAssert BGFX.getInterface(BGFX_API_VERSION - 1'u32) == nil
  doAssert BGFX.getInterface(BGFX_API_VERSION + 1'u32) == nil
  doAssert BGFX.getInterface(high(uint32)) == nil

  # A zero-capacity query reports the count without touching an output array.
  var renderer = BGFX_RENDERER_TYPE_COUNT
  let rendererCount = BGFX.getSupportedRenderers(0'u8, addr renderer)
  doAssert rendererCount > 0'u8
  doAssert rendererCount <= uint8(BGFX_RENDERER_TYPE_COUNT)
  doAssert renderer == BGFX_RENDERER_TYPE_COUNT
  doAssert BGFX.getSupportedRenderers(1'u8, addr renderer) == 1'u8
  doAssert renderer != BGFX_RENDERER_TYPE_COUNT

  # These combinations are rejected by bgfx's non-fatal validation API.
  doAssert BGFX.isTextureValid(
    1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8, BGFX_TEXTURE_NONE)
  doAssert not BGFX.isTextureValid(
    2, true, 1, BGFX_TEXTURE_FORMAT_RGBA8, BGFX_TEXTURE_NONE)
  doAssert not BGFX.isTextureValid(1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8,
    BGFX_TEXTURE_RT or BGFX_TEXTURE_READ_BACK)
  doAssert not BGFX.isTextureValid(1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8,
    BGFX_TEXTURE_COMPUTE_WRITE or BGFX_TEXTURE_READ_BACK)

  if caps.limits.maxTextureLayers < uint32(high(uint16)):
    let tooManyLayers = uint16(caps.limits.maxTextureLayers + 1'u32)
    doAssert not BGFX.isTextureValid(
      1, false, tooManyLayers, BGFX_TEXTURE_FORMAT_RGBA8, BGFX_TEXTURE_NONE)

  doAssert not BGFX.isFrameBufferValid(0'u8, nil)
  var attachment: bgfx_attachment_t
  attachment.handle = invalidHandle(bgfx_texture_handle_t)
  doAssert not BGFX.isFrameBufferValid(1'u8, addr attachment)

  # The NOOP-only build does not advertise hardware video decode.
  doAssert not BGFX.isVideoCodecValid(
    BGFX_VIDEO_CODEC_H264, 0, 8, 1920, 1080, 4, 3)

  BGFX.touch(0)
  discard BGFX.frame(BGFX_FRAME_NONE)
  echo "NOOP validation failure paths passed"
finally:
  BGFX.shutdown()
