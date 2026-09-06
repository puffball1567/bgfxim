# SPDX-License-Identifier: BSD-2-Clause

import bgfx

proc fatalCallback(this: ptr bgfx_callback_interface_t;
    filePath: bgfx_const_char_ptr_t; line: uint16; code: bgfx_fatal_t;
    message: bgfx_const_char_ptr_t) {.cdecl.} =
  discard

proc traceCallback(this: ptr bgfx_callback_interface_t;
    filePath: bgfx_const_char_ptr_t; line: uint16;
    format: bgfx_const_char_ptr_t; argList: bgfx_va_list_t) {.cdecl.} =
  discard

proc profilerBeginCallback(this: ptr bgfx_callback_interface_t;
    name: bgfx_const_char_ptr_t; abgr: uint32;
    filePath: bgfx_const_char_ptr_t; line: uint16) {.cdecl.} =
  discard

proc cacheWriteCallback(this: ptr bgfx_callback_interface_t; id: uint64;
    data: bgfx_const_void_ptr_t; size: uint32) {.cdecl.} =
  discard

proc screenShotCallback(this: ptr bgfx_callback_interface_t;
    filePath: bgfx_const_char_ptr_t; width, height, pitch: uint32;
    format: bgfx_texture_format_t; data: bgfx_const_void_ptr_t;
    size: uint32; yflip: bool) {.cdecl.} =
  discard

proc captureFrameCallback(this: ptr bgfx_callback_interface_t;
    data: bgfx_const_void_ptr_t; size: uint32) {.cdecl.} =
  discard

proc reallocCallback(this: ptr bgfx_allocator_interface_t; old: pointer;
    size, align: csize_t; file: bgfx_const_char_ptr_t;
    line: uint32): pointer {.cdecl.} =
  discard

var callbackVtable: bgfx_callback_vtbl_t
callbackVtable.fatal = fatalCallback
callbackVtable.trace_vargs = traceCallback
callbackVtable.profiler_begin = profilerBeginCallback
callbackVtable.profiler_begin_literal = profilerBeginCallback
callbackVtable.cache_write = cacheWriteCallback
callbackVtable.screen_shot = screenShotCallback
callbackVtable.capture_frame = captureFrameCallback

var allocatorVtable: bgfx_allocator_vtbl_t
allocatorVtable.realloc = reallocCallback

static:
  doAssert BGFX_API_VERSION == 159'u32
  doAssert BGFX_STATE_DEFAULT == 0x010000500000001f'u64
  doAssert BGFX_STATE_BLEND_ALPHA ==
    BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_SRC_ALPHA,
      BGFX_STATE_BLEND_INV_SRC_ALPHA)
  doAssert BGFX_SAMPLER_POINT == 0x00000540'u32
  doAssert sizeof(bgfx_texture_handle_t) == sizeof(uint16)
  doAssert sizeof(bgfx_caps_gpu_t) == 4

template assertCSize(bindingType: typedesc) =
  const nimSize = sizeof(bindingType)
  const typeName = astToStr(bindingType)
  {.emit: ["_Static_assert(sizeof(", typeName, ") == ", nimSize,
    ", \"bgfx binding size mismatch\");"].}

assertCSize(bgfx_allocator_interface_t)
assertCSize(bgfx_allocator_vtbl_t)
assertCSize(bgfx_interface_vtbl_t)
assertCSize(bgfx_callback_interface_t)
assertCSize(bgfx_callback_vtbl_t)
assertCSize(bgfx_dynamic_index_buffer_handle_t)
assertCSize(bgfx_dynamic_vertex_buffer_handle_t)
assertCSize(bgfx_buffer_handle_t)
assertCSize(bgfx_frame_buffer_handle_t)
assertCSize(bgfx_index_buffer_handle_t)
assertCSize(bgfx_indirect_buffer_handle_t)
assertCSize(bgfx_occlusion_query_handle_t)
assertCSize(bgfx_program_handle_t)
assertCSize(bgfx_shader_handle_t)
assertCSize(bgfx_texture_handle_t)
assertCSize(bgfx_uniform_handle_t)
assertCSize(bgfx_vertex_buffer_handle_t)
assertCSize(bgfx_vertex_layout_handle_t)
assertCSize(bgfx_caps_gpu_t)
assertCSize(bgfx_caps_limits_t)
assertCSize(bgfx_caps_t)
assertCSize(bgfx_internal_data_t)
assertCSize(bgfx_platform_data_t)
assertCSize(bgfx_swap_chain_t)
assertCSize(bgfx_init_limits_t)
assertCSize(bgfx_init_t)
assertCSize(bgfx_memory_t)
assertCSize(bgfx_transient_index_buffer_t)
assertCSize(bgfx_transient_vertex_buffer_t)
assertCSize(bgfx_instance_data_buffer_t)
assertCSize(bgfx_texture_info_t)
assertCSize(bgfx_texture_region_t)
assertCSize(bgfx_buffer_region_t)
assertCSize(bgfx_video_decoder_init_t)
assertCSize(bgfx_video_decoder_au_t)
assertCSize(bgfx_video_decoder_frame_t)
assertCSize(bgfx_uniform_info_t)
assertCSize(bgfx_attachment_t)
assertCSize(bgfx_transform_t)
assertCSize(bgfx_view_stats_t)
assertCSize(bgfx_encoder_stats_t)
assertCSize(bgfx_stats_t)
assertCSize(bgfx_vertex_layout_t)

proc exerciseApi() =
  var init: bgfx_init_t
  BGFX.initCtor(addr init)
  discard BGFX.init(addr init)
  BGFX.setDebug(BGFX_DEBUG_TEXT,
    invalidHandle(bgfx_frame_buffer_handle_t), 1'u8)
  BGFX.dbgTextPrintf(0'u16, 0'u16, 0x0f'u8, "%d", 42)

  var layout: bgfx_vertex_layout_t
  discard BGFX.vertexLayoutBegin(addr layout, BGFX_RENDERER_TYPE_COUNT)
  discard BGFX.vertexLayoutAdd(addr layout, BGFX_ATTRIB_POSITION, 3'u8,
    BGFX_ATTRIB_TYPE_FLOAT, false, false)
  BGFX.vertexLayoutEnd(addr layout)

  let texture = invalidHandle(bgfx_texture_handle_t)
  doAssert not BGFX_HANDLE_IS_VALID(texture)
  let caps: ptr bgfx_caps_t = BGFX.getCaps()
  let api: ptr bgfx_interface_vtbl_t = BGFX.getInterface(BGFX_API_VERSION)
  discard BGFX.bgfx_get_caps()
  discard BGFX.bgfx_get_interface(BGFX_API_VERSION)
  discard caps
  discard api
