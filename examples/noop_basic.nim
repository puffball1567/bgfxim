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
init.resolution.width = 64
init.resolution.height = 64

if not BGFX.init(addr init):
  raise newException(IOError, "bgfx NOOP initialization failed")

try:
  let renderer = BGFX.getRendererType()
  doAssert renderer == BGFX_RENDERER_TYPE_NOOP

  let caps = BGFX.getCaps()
  doAssert caps != nil
  doAssert caps.rendererType == renderer

  BGFX.setViewName(0, "noop-basic", 10)
  BGFX.setViewRect(0, 0, 0, 64, 64)
  BGFX.setViewClear(0, BGFX_CLEAR_COLOR, 0x303050ff'u32, 1.0, 0)
  BGFX.touch(0)
  let frameNumber = BGFX.frame(BGFX_FRAME_NONE)

  echo "renderer: ", $BGFX.getRendererName(renderer)
  echo "frame: ", frameNumber
  echo "basic NOOP calls passed"
finally:
  BGFX.shutdown()
