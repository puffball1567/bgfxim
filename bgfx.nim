# SPDX-License-Identifier: BSD-2-Clause
# Complete Nim bindings for the bgfx C99 API (API version 155).
#
# The binding code is BSD-2-Clause licensed. Declarations are derived from
# bgfx's BSD-2-Clause C99 headers. See LICENSE and THIRD_PARTY_NOTICES.md.
# Source: bgfx commit d8db55f8123a4a0871b1290fec2e5d0caae01bbf.
# Requires bgfx/c99/bgfx.h on the C include path and the bgfx library at link time.
#
# Usage:  import bgfx
#         BGFX.initCtor(addr init)

import bgfx/defines
export defines

type
  BGFX* = object  # namespace marker (zero-size)
  bgfx_va_list_t* {.importc: "va_list", header: "<stdarg.h>", bycopy.} = object
  bgfx_const_char_ptr_t* {.importc: "const char *", nodecl.} = cstring
  bgfx_const_void_ptr_t* {.importc: "const void *", nodecl.} = pointer
  bgfx_allocator_interface_s* {.importc: "bgfx_allocator_interface_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    vtbl*: ptr bgfx_allocator_vtbl_s
  bgfx_allocator_vtbl_s* {.importc: "bgfx_allocator_vtbl_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    realloc*: proc(this: ptr bgfx_allocator_interface_s; `ptr`: pointer;
      size: csize_t; align: csize_t; file: bgfx_const_char_ptr_t;
      line: uint32): pointer {.cdecl.}
  bgfx_interface_vtbl* {.importc: "bgfx_interface_vtbl_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    attachment_init*: proc(this: ptr bgfx_attachment_t; handle: bgfx_texture_handle_t; access: bgfx_access_t; layer: uint16; numLayers: uint16; mip: uint16; resolve: uint8) {.cdecl.}
    vertex_layout_begin*: proc(this: ptr bgfx_vertex_layout_t; rendererType: bgfx_renderer_type_t): ptr bgfx_vertex_layout_t {.cdecl.}
    vertex_layout_add*: proc(this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t; num: uint8; `type`: bgfx_attrib_type_t; normalized: bool; asInt: bool): ptr bgfx_vertex_layout_t {.cdecl.}
    vertex_layout_decode*: proc(this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t; num: ptr uint8; `type`: ptr bgfx_attrib_type_t; normalized: ptr bool; asInt: ptr bool) {.cdecl.}
    vertex_layout_has*: proc(this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t): bool {.cdecl.}
    vertex_layout_skip*: proc(this: ptr bgfx_vertex_layout_t; num: uint8): ptr bgfx_vertex_layout_t {.cdecl.}
    vertex_layout_end*: proc(this: ptr bgfx_vertex_layout_t) {.cdecl.}
    vertex_layout_get_offset*: proc(this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t): uint16 {.cdecl.}
    vertex_layout_get_stride*: proc(this: ptr bgfx_vertex_layout_t): uint16 {.cdecl.}
    vertex_layout_get_size*: proc(this: ptr bgfx_vertex_layout_t; num: uint32): uint32 {.cdecl.}
    vertex_pack*: proc(input: array[4, cfloat]; inputNormalized: bool; attr: bgfx_attrib_t; layout: ptr bgfx_vertex_layout_t; data: pointer; index: uint32) {.cdecl.}
    vertex_unpack*: proc(output: var array[4, cfloat]; attr: bgfx_attrib_t; layout: ptr bgfx_vertex_layout_t; data: pointer; index: uint32) {.cdecl.}
    vertex_convert*: proc(dstLayout: ptr bgfx_vertex_layout_t; dstData: pointer; srcLayout: ptr bgfx_vertex_layout_t; srcData: pointer; num: uint32) {.cdecl.}
    topology_convert*: proc(conversion: bgfx_topology_convert_t; dst: pointer; dstSize: uint32; indices: pointer; numIndices: uint32; index32: bool): uint32 {.cdecl.}
    topology_sort_tri_list*: proc(sort: bgfx_topology_sort_t; dst: pointer; dstSize: uint32; dir: array[3, cfloat]; pos: array[3, cfloat]; vertices: pointer; stride: uint32; indices: pointer; numIndices: uint32; index32: bool) {.cdecl.}
    get_supported_renderers*: proc(max: uint8; `enum`: ptr bgfx_renderer_type_t): uint8 {.cdecl.}
    get_renderer_name*: proc(`type`: bgfx_renderer_type_t): cstring {.cdecl.}
    init_ctor*: proc(init: ptr bgfx_init_t) {.cdecl.}
    init*: proc(init: ptr bgfx_init_t): bool {.cdecl.}
    shutdown*: proc() {.cdecl.}
    reset*: proc(width: uint32; height: uint32; flags: uint32; format: bgfx_texture_format_t) {.cdecl.}
    frame*: proc(flags: uint8): uint32 {.cdecl.}
    get_renderer_type*: proc(): bgfx_renderer_type_t {.cdecl.}
    get_caps*: proc(): ptr bgfx_caps_t {.cdecl.}
    get_stats*: proc(): ptr bgfx_stats_t {.cdecl.}
    alloc*: proc(size: uint32): ptr bgfx_memory_t {.cdecl.}
    copy*: proc(data: pointer; size: uint32): ptr bgfx_memory_t {.cdecl.}
    make_ref*: proc(data: pointer; size: uint32): ptr bgfx_memory_t {.cdecl.}
    make_ref_release*: proc(data: pointer; size: uint32; releaseFn: bgfx_release_fn_t; userData: pointer): ptr bgfx_memory_t {.cdecl.}
    set_debug*: proc(debug: uint32) {.cdecl.}
    dbg_text_clear*: proc(attr: uint8; small: bool) {.cdecl.}
    dbg_text_printf*: proc(x: uint16; y: uint16; attr: uint8; format: cstring) {.cdecl, varargs.}
    dbg_text_vprintf*: proc(x: uint16; y: uint16; attr: uint8; format: cstring; argList: bgfx_va_list_t) {.cdecl.}
    dbg_text_image*: proc(x: uint16; y: uint16; width: uint16; height: uint16; data: pointer; pitch: uint16) {.cdecl.}
    create_index_buffer*: proc(mem: ptr bgfx_memory_t; flags: uint16): bgfx_index_buffer_handle_t {.cdecl.}
    set_index_buffer_name*: proc(handle: bgfx_index_buffer_handle_t; name: cstring; len: int32) {.cdecl.}
    destroy_index_buffer*: proc(handle: bgfx_index_buffer_handle_t) {.cdecl.}
    create_vertex_layout*: proc(layout: ptr bgfx_vertex_layout_t): bgfx_vertex_layout_handle_t {.cdecl.}
    destroy_vertex_layout*: proc(layoutHandle: bgfx_vertex_layout_handle_t) {.cdecl.}
    create_vertex_buffer*: proc(mem: ptr bgfx_memory_t; layout: ptr bgfx_vertex_layout_t; flags: uint16): bgfx_vertex_buffer_handle_t {.cdecl.}
    set_vertex_buffer_name*: proc(handle: bgfx_vertex_buffer_handle_t; name: cstring; len: int32) {.cdecl.}
    destroy_vertex_buffer*: proc(handle: bgfx_vertex_buffer_handle_t) {.cdecl.}
    create_dynamic_index_buffer*: proc(num: uint32; flags: uint16): bgfx_dynamic_index_buffer_handle_t {.cdecl.}
    create_dynamic_index_buffer_mem*: proc(mem: ptr bgfx_memory_t; flags: uint16): bgfx_dynamic_index_buffer_handle_t {.cdecl.}
    update_dynamic_index_buffer*: proc(handle: bgfx_dynamic_index_buffer_handle_t; startIndex: uint32; mem: ptr bgfx_memory_t) {.cdecl.}
    destroy_dynamic_index_buffer*: proc(handle: bgfx_dynamic_index_buffer_handle_t) {.cdecl.}
    create_dynamic_vertex_buffer*: proc(num: uint32; layout: ptr bgfx_vertex_layout_t; flags: uint16): bgfx_dynamic_vertex_buffer_handle_t {.cdecl.}
    create_dynamic_vertex_buffer_mem*: proc(mem: ptr bgfx_memory_t; layout: ptr bgfx_vertex_layout_t; flags: uint16): bgfx_dynamic_vertex_buffer_handle_t {.cdecl.}
    update_dynamic_vertex_buffer*: proc(handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; mem: ptr bgfx_memory_t) {.cdecl.}
    destroy_dynamic_vertex_buffer*: proc(handle: bgfx_dynamic_vertex_buffer_handle_t) {.cdecl.}
    get_avail_transient_index_buffer*: proc(num: uint32; index32: bool): uint32 {.cdecl.}
    get_avail_transient_vertex_buffer*: proc(num: uint32; layout: ptr bgfx_vertex_layout_t): uint32 {.cdecl.}
    get_avail_instance_data_buffer*: proc(num: uint32; stride: uint16): uint32 {.cdecl.}
    alloc_transient_index_buffer*: proc(tib: ptr bgfx_transient_index_buffer_t; num: uint32; index32: bool) {.cdecl.}
    alloc_transient_vertex_buffer*: proc(tvb: ptr bgfx_transient_vertex_buffer_t; num: uint32; layout: ptr bgfx_vertex_layout_t) {.cdecl.}
    alloc_transient_buffers*: proc(tvb: ptr bgfx_transient_vertex_buffer_t; layout: ptr bgfx_vertex_layout_t; numVertices: uint32; tib: ptr bgfx_transient_index_buffer_t; numIndices: uint32; index32: bool): bool {.cdecl.}
    alloc_instance_data_buffer*: proc(idb: ptr bgfx_instance_data_buffer_t; num: uint32; stride: uint16) {.cdecl.}
    create_indirect_buffer*: proc(num: uint32): bgfx_indirect_buffer_handle_t {.cdecl.}
    destroy_indirect_buffer*: proc(handle: bgfx_indirect_buffer_handle_t) {.cdecl.}
    create_shader*: proc(mem: ptr bgfx_memory_t): bgfx_shader_handle_t {.cdecl.}
    get_shader_uniforms*: proc(handle: bgfx_shader_handle_t; uniforms: ptr bgfx_uniform_handle_t; max: uint16): uint16 {.cdecl.}
    set_shader_name*: proc(handle: bgfx_shader_handle_t; name: cstring; len: int32) {.cdecl.}
    destroy_shader*: proc(handle: bgfx_shader_handle_t) {.cdecl.}
    create_program*: proc(vsh: bgfx_shader_handle_t; fsh: bgfx_shader_handle_t; destroyShaders: bool): bgfx_program_handle_t {.cdecl.}
    create_compute_program*: proc(csh: bgfx_shader_handle_t; destroyShaders: bool): bgfx_program_handle_t {.cdecl.}
    destroy_program*: proc(handle: bgfx_program_handle_t) {.cdecl.}
    is_texture_valid*: proc(depth: uint16; cubeMap: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64): bool {.cdecl.}
    is_video_codec_valid*: proc(codec: bgfx_video_codec_t; chroma: uint8; bitDepth: uint8; codedWidth: uint16; codedHeight: uint16; maxDpbSlots: uint8; maxActiveReferences: uint8): bool {.cdecl.}
    is_frame_buffer_valid*: proc(num: uint8; attachment: ptr bgfx_attachment_t): bool {.cdecl.}
    calc_texture_size*: proc(info: ptr bgfx_texture_info_t; width: uint16; height: uint16; depth: uint16; cubeMap: bool; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t) {.cdecl.}
    create_texture*: proc(mem: ptr bgfx_memory_t; flags: uint64; skip: uint8; info: ptr bgfx_texture_info_t): bgfx_texture_handle_t {.cdecl.}
    create_texture_2d*: proc(width: uint16; height: uint16; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64; mem: ptr bgfx_memory_t; external: uint64): bgfx_texture_handle_t {.cdecl.}
    create_texture_2d_scaled*: proc(ratio: bgfx_backbuffer_ratio_t; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64): bgfx_texture_handle_t {.cdecl.}
    create_texture_3d*: proc(width: uint16; height: uint16; depth: uint16; hasMips: bool; format: bgfx_texture_format_t; flags: uint64; mem: ptr bgfx_memory_t; external: uint64): bgfx_texture_handle_t {.cdecl.}
    create_texture_cube*: proc(size: uint16; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64; mem: ptr bgfx_memory_t; external: uint64): bgfx_texture_handle_t {.cdecl.}
    update_texture_2d*: proc(handle: bgfx_texture_handle_t; layer: uint16; mip: uint8; x: uint16; y: uint16; width: uint16; height: uint16; mem: ptr bgfx_memory_t; pitch: uint16) {.cdecl.}
    update_texture_3d*: proc(handle: bgfx_texture_handle_t; mip: uint8; x: uint16; y: uint16; z: uint16; width: uint16; height: uint16; depth: uint16; mem: ptr bgfx_memory_t) {.cdecl.}
    update_texture_cube*: proc(handle: bgfx_texture_handle_t; layer: uint16; side: uint8; mip: uint8; x: uint16; y: uint16; width: uint16; height: uint16; mem: ptr bgfx_memory_t; pitch: uint16) {.cdecl.}
    clear_texture*: proc(handle: bgfx_texture_handle_t; mip: uint8; numMips: uint8; layer: uint16; numLayers: uint16) {.cdecl.}
    read_texture*: proc(handle: bgfx_texture_handle_t; data: pointer; layer: uint16; mip: uint8): uint32 {.cdecl.}
    set_texture_name*: proc(handle: bgfx_texture_handle_t; name: cstring; len: int32) {.cdecl.}
    get_direct_access_ptr*: proc(handle: bgfx_texture_handle_t): pointer {.cdecl.}
    destroy_texture*: proc(handle: bgfx_texture_handle_t) {.cdecl.}
    create_frame_buffer*: proc(width: uint16; height: uint16; format: bgfx_texture_format_t; textureFlags: uint64): bgfx_frame_buffer_handle_t {.cdecl.}
    create_frame_buffer_scaled*: proc(ratio: bgfx_backbuffer_ratio_t; format: bgfx_texture_format_t; textureFlags: uint64): bgfx_frame_buffer_handle_t {.cdecl.}
    create_frame_buffer_from_handles*: proc(num: uint8; handles: ptr bgfx_texture_handle_t; destroyTexture: bool): bgfx_frame_buffer_handle_t {.cdecl.}
    create_frame_buffer_from_attachment*: proc(num: uint8; attachment: ptr bgfx_attachment_t; destroyTexture: bool): bgfx_frame_buffer_handle_t {.cdecl.}
    create_frame_buffer_from_nwh*: proc(nwh: pointer; width: uint16; height: uint16; format: bgfx_texture_format_t; depthFormat: bgfx_texture_format_t): bgfx_frame_buffer_handle_t {.cdecl.}
    set_frame_buffer_name*: proc(handle: bgfx_frame_buffer_handle_t; name: cstring; len: int32) {.cdecl.}
    get_texture*: proc(handle: bgfx_frame_buffer_handle_t; attachment: uint8): bgfx_texture_handle_t {.cdecl.}
    destroy_frame_buffer*: proc(handle: bgfx_frame_buffer_handle_t) {.cdecl.}
    create_uniform*: proc(name: cstring; `type`: bgfx_uniform_type_t; num: uint16): bgfx_uniform_handle_t {.cdecl.}
    create_uniform_with_freq*: proc(name: cstring; freq: bgfx_uniform_freq_t; `type`: bgfx_uniform_type_t; num: uint16): bgfx_uniform_handle_t {.cdecl.}
    get_uniform_info*: proc(handle: bgfx_uniform_handle_t; info: ptr bgfx_uniform_info_t) {.cdecl.}
    destroy_uniform*: proc(handle: bgfx_uniform_handle_t) {.cdecl.}
    create_occlusion_query*: proc(): bgfx_occlusion_query_handle_t {.cdecl.}
    get_result*: proc(handle: bgfx_occlusion_query_handle_t; result: ptr int32): bgfx_occlusion_query_result_t {.cdecl.}
    destroy_occlusion_query*: proc(handle: bgfx_occlusion_query_handle_t) {.cdecl.}
    set_palette_color*: proc(index: uint8; rgba: array[4, cfloat]) {.cdecl.}
    set_palette_color_rgba32f*: proc(index: uint8; r: cfloat; g: cfloat; b: cfloat; a: cfloat) {.cdecl.}
    set_palette_color_rgba8*: proc(index: uint8; rgba: uint32) {.cdecl.}
    set_view_name*: proc(id: bgfx_view_id_t; name: cstring; len: int32) {.cdecl.}
    set_view_rect*: proc(id: bgfx_view_id_t; x: int16; y: int16; width: uint16; height: uint16) {.cdecl.}
    set_view_rect_ratio*: proc(id: bgfx_view_id_t; x: int16; y: int16; ratio: bgfx_backbuffer_ratio_t) {.cdecl.}
    set_view_scissor*: proc(id: bgfx_view_id_t; x: uint16; y: uint16; width: uint16; height: uint16) {.cdecl.}
    set_view_clear*: proc(id: bgfx_view_id_t; flags: uint16; rgba: uint32; depth: cfloat; stencil: uint8) {.cdecl.}
    set_view_clear_mrt*: proc(id: bgfx_view_id_t; flags: uint16; depth: cfloat; stencil: uint8; c0: uint8; c1: uint8; c2: uint8; c3: uint8; c4: uint8; c5: uint8; c6: uint8; c7: uint8) {.cdecl.}
    set_view_mode*: proc(id: bgfx_view_id_t; mode: bgfx_view_mode_t) {.cdecl.}
    set_view_frame_buffer*: proc(id: bgfx_view_id_t; handle: bgfx_frame_buffer_handle_t) {.cdecl.}
    set_view_transform*: proc(id: bgfx_view_id_t; view: pointer; proj: pointer) {.cdecl.}
    set_view_order*: proc(id: bgfx_view_id_t; num: uint16; order: ptr bgfx_view_id_t) {.cdecl.}
    set_view_shading_rate*: proc(id: bgfx_view_id_t; shadingRate: bgfx_shading_rate_t) {.cdecl.}
    reset_view*: proc(id: bgfx_view_id_t) {.cdecl.}
    encoder_begin*: proc(forceNewEncoder: bool): ptr bgfx_encoder_t {.cdecl.}
    encoder_end*: proc(encoder: ptr bgfx_encoder_t) {.cdecl.}
    encoder_set_marker*: proc(this: ptr bgfx_encoder_t; name: cstring; len: int32) {.cdecl.}
    encoder_set_state*: proc(this: ptr bgfx_encoder_t; state: uint64; rgba: uint32) {.cdecl.}
    encoder_set_condition*: proc(this: ptr bgfx_encoder_t; handle: bgfx_occlusion_query_handle_t; visible: bool) {.cdecl.}
    encoder_set_stencil*: proc(this: ptr bgfx_encoder_t; fstencil: uint32; bstencil: uint32) {.cdecl.}
    encoder_set_scissor*: proc(this: ptr bgfx_encoder_t; x: uint16; y: uint16; width: uint16; height: uint16): uint16 {.cdecl.}
    encoder_set_scissor_cached*: proc(this: ptr bgfx_encoder_t; cache: uint16) {.cdecl.}
    encoder_set_transform*: proc(this: ptr bgfx_encoder_t; mtx: pointer; num: uint16): uint32 {.cdecl.}
    encoder_set_transform_cached*: proc(this: ptr bgfx_encoder_t; cache: uint32; num: uint16) {.cdecl.}
    encoder_alloc_transform*: proc(this: ptr bgfx_encoder_t; transform: ptr bgfx_transform_t; num: uint16): uint32 {.cdecl.}
    encoder_set_uniform*: proc(this: ptr bgfx_encoder_t; handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.cdecl.}
    set_view_uniform*: proc(id: bgfx_view_id_t; handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.cdecl.}
    set_frame_uniform*: proc(handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.cdecl.}
    encoder_set_index_buffer*: proc(this: ptr bgfx_encoder_t; handle: bgfx_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.cdecl.}
    encoder_set_dynamic_index_buffer*: proc(this: ptr bgfx_encoder_t; handle: bgfx_dynamic_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.cdecl.}
    encoder_set_transient_index_buffer*: proc(this: ptr bgfx_encoder_t; tib: ptr bgfx_transient_index_buffer_t; firstIndex: uint32; numIndices: uint32) {.cdecl.}
    encoder_set_vertex_buffer*: proc(this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.cdecl.}
    encoder_set_vertex_buffer_with_layout*: proc(this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.cdecl.}
    encoder_set_dynamic_vertex_buffer*: proc(this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.cdecl.}
    encoder_set_dynamic_vertex_buffer_with_layout*: proc(this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.cdecl.}
    encoder_set_transient_vertex_buffer*: proc(this: ptr bgfx_encoder_t; stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32) {.cdecl.}
    encoder_set_transient_vertex_buffer_with_layout*: proc(this: ptr bgfx_encoder_t; stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.cdecl.}
    encoder_set_vertex_count*: proc(this: ptr bgfx_encoder_t; numVertices: uint32) {.cdecl.}
    encoder_set_instance_data_buffer*: proc(this: ptr bgfx_encoder_t; idb: ptr bgfx_instance_data_buffer_t; start: uint32; num: uint32) {.cdecl.}
    encoder_set_instance_data_from_vertex_buffer*: proc(this: ptr bgfx_encoder_t; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.cdecl.}
    encoder_set_instance_data_from_dynamic_vertex_buffer*: proc(this: ptr bgfx_encoder_t; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.cdecl.}
    encoder_set_instance_count*: proc(this: ptr bgfx_encoder_t; numInstances: uint32) {.cdecl.}
    encoder_set_texture*: proc(this: ptr bgfx_encoder_t; stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; flags: uint32) {.cdecl.}
    encoder_set_texture_view*: proc(this: ptr bgfx_encoder_t; stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; firstMip: uint8; numMips: uint8; flags: uint32) {.cdecl.}
    encoder_touch*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t) {.cdecl.}
    encoder_submit*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; depth: uint32; flags: uint8) {.cdecl.}
    encoder_submit_occlusion_query*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; occlusionQuery: bgfx_occlusion_query_handle_t; depth: uint32; flags: uint8) {.cdecl.}
    encoder_submit_indirect*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; depth: uint32; flags: uint8) {.cdecl.}
    encoder_submit_indirect_count*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; numHandle: bgfx_index_buffer_handle_t; numIndex: uint32; numMax: uint32; depth: uint32; flags: uint8) {.cdecl.}
    encoder_set_compute_index_buffer*: proc(this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_index_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    encoder_set_compute_vertex_buffer*: proc(this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_vertex_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    encoder_set_compute_dynamic_index_buffer*: proc(this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_dynamic_index_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    encoder_set_compute_dynamic_vertex_buffer*: proc(this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    encoder_set_compute_indirect_buffer*: proc(this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_indirect_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    encoder_set_image*: proc(this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_texture_handle_t; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.cdecl.}
    encoder_set_image_view*: proc(this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.cdecl.}
    encoder_dispatch*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; numX: uint32; numY: uint32; numZ: uint32; flags: uint8) {.cdecl.}
    encoder_dispatch_indirect*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; flags: uint8) {.cdecl.}
    encoder_discard*: proc(this: ptr bgfx_encoder_t; flags: uint8) {.cdecl.}
    encoder_blit*: proc(this: ptr bgfx_encoder_t; id: bgfx_view_id_t; dst: bgfx_texture_handle_t; dstMip: uint8; dstX: uint16; dstY: uint16; dstZ: uint16; src: bgfx_texture_handle_t; srcMip: uint8; srcX: uint16; srcY: uint16; srcZ: uint16; width: uint16; height: uint16; depth: uint16) {.cdecl.}
    request_screen_shot*: proc(handle: bgfx_frame_buffer_handle_t; filePath: cstring) {.cdecl.}
    render_frame*: proc(msecs: int32): bgfx_render_frame_t {.cdecl.}
    set_platform_data*: proc(data: ptr bgfx_platform_data_t) {.cdecl.}
    get_internal_data*: proc(): ptr bgfx_internal_data_t {.cdecl.}
    override_internal_texture_ptr*: proc(handle: bgfx_texture_handle_t; `ptr`: uint; layerIndex: uint16): uint {.cdecl.}
    override_internal_texture*: proc(handle: bgfx_texture_handle_t; width: uint16; height: uint16; numMips: uint8; format: bgfx_texture_format_t; flags: uint64): uint {.cdecl.}
    set_marker*: proc(name: cstring; len: int32) {.cdecl.}
    set_state*: proc(state: uint64; rgba: uint32) {.cdecl.}
    set_condition*: proc(handle: bgfx_occlusion_query_handle_t; visible: bool) {.cdecl.}
    set_stencil*: proc(fstencil: uint32; bstencil: uint32) {.cdecl.}
    set_scissor*: proc(x: uint16; y: uint16; width: uint16; height: uint16): uint16 {.cdecl.}
    set_scissor_cached*: proc(cache: uint16) {.cdecl.}
    set_transform*: proc(mtx: pointer; num: uint16): uint32 {.cdecl.}
    set_transform_cached*: proc(cache: uint32; num: uint16) {.cdecl.}
    alloc_transform*: proc(transform: ptr bgfx_transform_t; num: uint16): uint32 {.cdecl.}
    set_uniform*: proc(handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.cdecl.}
    set_index_buffer*: proc(handle: bgfx_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.cdecl.}
    set_dynamic_index_buffer*: proc(handle: bgfx_dynamic_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.cdecl.}
    set_transient_index_buffer*: proc(tib: ptr bgfx_transient_index_buffer_t; firstIndex: uint32; numIndices: uint32) {.cdecl.}
    set_vertex_buffer*: proc(stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.cdecl.}
    set_vertex_buffer_with_layout*: proc(stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.cdecl.}
    set_dynamic_vertex_buffer*: proc(stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.cdecl.}
    set_dynamic_vertex_buffer_with_layout*: proc(stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.cdecl.}
    set_transient_vertex_buffer*: proc(stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32) {.cdecl.}
    set_transient_vertex_buffer_with_layout*: proc(stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.cdecl.}
    set_vertex_count*: proc(numVertices: uint32) {.cdecl.}
    set_instance_data_buffer*: proc(idb: ptr bgfx_instance_data_buffer_t; start: uint32; num: uint32) {.cdecl.}
    set_instance_data_from_vertex_buffer*: proc(handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.cdecl.}
    set_instance_data_from_dynamic_vertex_buffer*: proc(handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.cdecl.}
    set_instance_count*: proc(numInstances: uint32) {.cdecl.}
    set_texture*: proc(stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; flags: uint32) {.cdecl.}
    set_texture_view*: proc(stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; firstMip: uint8; numMips: uint8; flags: uint32) {.cdecl.}
    touch*: proc(id: bgfx_view_id_t) {.cdecl.}
    submit*: proc(id: bgfx_view_id_t; program: bgfx_program_handle_t; depth: uint32; flags: uint8) {.cdecl.}
    submit_occlusion_query*: proc(id: bgfx_view_id_t; program: bgfx_program_handle_t; occlusionQuery: bgfx_occlusion_query_handle_t; depth: uint32; flags: uint8) {.cdecl.}
    submit_indirect*: proc(id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; depth: uint32; flags: uint8) {.cdecl.}
    submit_indirect_count*: proc(id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; numHandle: bgfx_index_buffer_handle_t; numIndex: uint32; numMax: uint32; depth: uint32; flags: uint8) {.cdecl.}
    set_compute_index_buffer*: proc(stage: uint8; handle: bgfx_index_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    set_compute_vertex_buffer*: proc(stage: uint8; handle: bgfx_vertex_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    set_compute_dynamic_index_buffer*: proc(stage: uint8; handle: bgfx_dynamic_index_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    set_compute_dynamic_vertex_buffer*: proc(stage: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    set_compute_indirect_buffer*: proc(stage: uint8; handle: bgfx_indirect_buffer_handle_t; access: bgfx_access_t) {.cdecl.}
    set_image*: proc(stage: uint8; handle: bgfx_texture_handle_t; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.cdecl.}
    set_image_view*: proc(stage: uint8; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.cdecl.}
    dispatch*: proc(id: bgfx_view_id_t; program: bgfx_program_handle_t; numX: uint32; numY: uint32; numZ: uint32; flags: uint8) {.cdecl.}
    dispatch_indirect*: proc(id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; flags: uint8) {.cdecl.}
    `discard`*: proc(flags: uint8) {.cdecl.}
    blit*: proc(id: bgfx_view_id_t; dst: bgfx_texture_handle_t; dstMip: uint8; dstX: uint16; dstY: uint16; dstZ: uint16; src: bgfx_texture_handle_t; srcMip: uint8; srcX: uint16; srcY: uint16; srcZ: uint16; width: uint16; height: uint16; depth: uint16) {.cdecl.}
  bgfx_callback_interface_s* {.importc: "bgfx_callback_interface_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    vtbl*: ptr bgfx_callback_vtbl_s
  bgfx_callback_vtbl_s* {.importc: "bgfx_callback_vtbl_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    fatal*: proc(this: ptr bgfx_callback_interface_s;
      filePath: bgfx_const_char_ptr_t; line: uint16; code: bgfx_fatal_t;
      str: bgfx_const_char_ptr_t) {.cdecl.}
    trace_vargs*: proc(this: ptr bgfx_callback_interface_s;
      filePath: bgfx_const_char_ptr_t; line: uint16;
      format: bgfx_const_char_ptr_t; argList: bgfx_va_list_t) {.cdecl.}
    profiler_begin*: proc(this: ptr bgfx_callback_interface_s;
      name: bgfx_const_char_ptr_t; abgr: uint32;
      filePath: bgfx_const_char_ptr_t; line: uint16) {.cdecl.}
    profiler_begin_literal*: proc(this: ptr bgfx_callback_interface_s;
      name: bgfx_const_char_ptr_t; abgr: uint32;
      filePath: bgfx_const_char_ptr_t; line: uint16) {.cdecl.}
    profiler_end*: proc(this: ptr bgfx_callback_interface_s) {.cdecl.}
    cache_read_size*: proc(this: ptr bgfx_callback_interface_s; id: uint64): uint32 {.cdecl.}
    cache_read*: proc(this: ptr bgfx_callback_interface_s; id: uint64;
      data: pointer; size: uint32): bool {.cdecl.}
    cache_write*: proc(this: ptr bgfx_callback_interface_s; id: uint64;
      data: bgfx_const_void_ptr_t; size: uint32) {.cdecl.}
    screen_shot*: proc(this: ptr bgfx_callback_interface_s;
      filePath: bgfx_const_char_ptr_t;
      width: uint32; height: uint32; pitch: uint32; format: bgfx_texture_format_t;
      data: bgfx_const_void_ptr_t; size: uint32; yflip: bool) {.cdecl.}
    capture_begin*: proc(this: ptr bgfx_callback_interface_s; width: uint32;
      height: uint32; pitch: uint32; format: bgfx_texture_format_t;
      yflip: bool) {.cdecl.}
    capture_end*: proc(this: ptr bgfx_callback_interface_s) {.cdecl.}
    capture_frame*: proc(this: ptr bgfx_callback_interface_s;
      data: bgfx_const_void_ptr_t; size: uint32) {.cdecl.}
  bgfx_dynamic_index_buffer_handle_s* {.importc: "bgfx_dynamic_index_buffer_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_dynamic_vertex_buffer_handle_s* {.importc: "bgfx_dynamic_vertex_buffer_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_frame_buffer_handle_s* {.importc: "bgfx_frame_buffer_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_index_buffer_handle_s* {.importc: "bgfx_index_buffer_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_indirect_buffer_handle_s* {.importc: "bgfx_indirect_buffer_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_occlusion_query_handle_s* {.importc: "bgfx_occlusion_query_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_program_handle_s* {.importc: "bgfx_program_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_shader_handle_s* {.importc: "bgfx_shader_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_texture_handle_s* {.importc: "bgfx_texture_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_uniform_handle_s* {.importc: "bgfx_uniform_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_vertex_buffer_handle_s* {.importc: "bgfx_vertex_buffer_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_vertex_layout_handle_s* {.importc: "bgfx_vertex_layout_handle_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    idx*: uint16
  bgfx_caps_gpu_s* {.importc: "bgfx_caps_gpu_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    vendorId*: uint16
    deviceId*: uint16
  bgfx_caps_limits_s* {.importc: "bgfx_caps_limits_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    maxDrawCalls*: uint32
    maxBlits*: uint32
    maxTextureSize*: uint32
    maxTextureLayers*: uint32
    maxViews*: uint32
    maxFrameBuffers*: uint32
    maxFBAttachments*: uint32
    maxPrograms*: uint32
    maxShaders*: uint32
    maxTextures*: uint32
    maxTextureSamplers*: uint32
    maxComputeBindings*: uint32
    maxVertexLayouts*: uint32
    maxVertexStreams*: uint32
    maxVertexAttributes*: uint32
    maxInstanceData*: uint32
    maxIndexBuffers*: uint32
    maxVertexBuffers*: uint32
    maxDynamicIndexBuffers*: uint32
    maxDynamicVertexBuffers*: uint32
    maxUniforms*: uint32
    maxOcclusionQueries*: uint32
    maxEncoders*: uint32
    minResourceCbSize*: uint32
    maxTransientVbSize*: uint32
    maxTransientIbSize*: uint32
    minUniformBufferSize*: uint32
  bgfx_caps_s* {.importc: "bgfx_caps_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    rendererType*: bgfx_renderer_type_t
    supported*: uint64
    vendorId*: uint16
    deviceId*: uint16
    homogeneousDepth*: bool
    originBottomLeft*: bool
    numGPUs*: uint8
    gpu*: array[4, bgfx_caps_gpu_t]
    limits*: bgfx_caps_limits_t
    formats*: array[105, uint32]
    codecs*: array[3, uint32]
  bgfx_internal_data_s* {.importc: "bgfx_internal_data_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    caps*: ptr bgfx_caps_t
    context*: pointer
  bgfx_platform_data_s* {.importc: "bgfx_platform_data_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    ndt*: pointer
    nwh*: pointer
    context*: pointer
    queue*: pointer
    backBuffer*: pointer
    backBufferDS*: pointer
    `type`*: bgfx_native_window_handle_type_t
  bgfx_resolution_s* {.importc: "bgfx_resolution_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    formatColor*: bgfx_texture_format_t
    formatDepthStencil*: bgfx_texture_format_t
    width*: uint32
    height*: uint32
    reset*: uint32
    numBackBuffers*: uint8
    maxFrameLatency*: uint8
    debugTextScale*: uint8
  bgfx_init_limits_s* {.importc: "bgfx_init_limits_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    maxEncoders*: uint16
    numDrawCalls*: uint32
    numDrawCallPeakFrames*: uint32
    minResourceCbSize*: uint32
    maxTransientVbSize*: uint32
    maxTransientIbSize*: uint32
    minUniformBufferSize*: uint32
  bgfx_init_s* {.importc: "bgfx_init_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    `type`*: bgfx_renderer_type_t
    vendorId*: uint16
    deviceId*: uint16
    capabilities*: uint64
    debug*: bool
    profile*: bool
    fallback*: bool
    videoDecode*: bool
    platformData*: bgfx_platform_data_t
    resolution*: bgfx_resolution_t
    limits*: bgfx_init_limits_t
    callback*: ptr bgfx_callback_interface_t
    allocator*: ptr bgfx_allocator_interface_t
  bgfx_memory_s* {.importc: "bgfx_memory_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    data*: ptr uint8
    size*: uint32
  bgfx_transient_index_buffer_s* {.importc: "bgfx_transient_index_buffer_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    data*: ptr uint8
    size*: uint32
    startIndex*: uint32
    handle*: bgfx_index_buffer_handle_t
    isIndex16*: bool
  bgfx_transient_vertex_buffer_s* {.importc: "bgfx_transient_vertex_buffer_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    data*: ptr uint8
    size*: uint32
    startVertex*: uint32
    stride*: uint16
    handle*: bgfx_vertex_buffer_handle_t
    layoutHandle*: bgfx_vertex_layout_handle_t
  bgfx_instance_data_buffer_s* {.importc: "bgfx_instance_data_buffer_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    data*: ptr uint8
    size*: uint32
    offset*: uint32
    num*: uint32
    stride*: uint16
    handle*: bgfx_vertex_buffer_handle_t
  bgfx_texture_info_s* {.importc: "bgfx_texture_info_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    format*: bgfx_texture_format_t
    storageSize*: uint32
    width*: uint16
    height*: uint16
    depth*: uint16
    numLayers*: uint16
    numMips*: uint8
    bitsPerPixel*: uint8
    cubeMap*: bool
  bgfx_video_decoder_init_s* {.importc: "bgfx_video_decoder_init_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    magic*: uint32
    codec*: bgfx_video_codec_t
    parameterSets*: ptr uint8
    parameterSetsSize*: uint32
    cachedAuBytes*: uint32
    flags*: uint8
  bgfx_video_decoder_au_s* {.importc: "bgfx_video_decoder_au_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    size*: uint32
    ptsUs*: int64
  bgfx_video_decoder_frame_s* {.importc: "bgfx_video_decoder_frame_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    magic*: uint32
    bitstream*: ptr uint8
    aus*: ptr bgfx_video_decoder_au_t
    numAus*: uint32
    presentationTimeUs*: int64
    flags*: uint8
  bgfx_uniform_info_s* {.importc: "bgfx_uniform_info_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    name*: array[256, cchar]
    `type`*: bgfx_uniform_type_t
    num*: uint16
  bgfx_attachment_s* {.importc: "bgfx_attachment_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    access*: bgfx_access_t
    handle*: bgfx_texture_handle_t
    mip*: uint16
    layer*: uint16
    numLayers*: uint16
    resolve*: uint8
  bgfx_transform_s* {.importc: "bgfx_transform_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    data*: ptr cfloat
    num*: uint16
  bgfx_view_stats_s* {.importc: "bgfx_view_stats_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    name*: array[256, cchar]
    view*: bgfx_view_id_t
    cpuTimeBegin*: int64
    cpuTimeEnd*: int64
    gpuTimeBegin*: int64
    gpuTimeEnd*: int64
    gpuFrameNum*: uint32
  bgfx_encoder_stats_s* {.importc: "bgfx_encoder_stats_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    cpuTimeBegin*: int64
    cpuTimeEnd*: int64
  bgfx_stats_s* {.importc: "bgfx_stats_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    cpuTimeFrame*: int64
    cpuTimeBegin*: int64
    cpuTimeEnd*: int64
    cpuTimerFreq*: int64
    gpuTimeBegin*: int64
    gpuTimeEnd*: int64
    gpuTimerFreq*: int64
    waitRender*: int64
    waitSubmit*: int64
    numDraw*: uint32
    numCompute*: uint32
    numBlit*: uint32
    numDrawCallsPeak*: uint32
    maxGpuLatency*: uint32
    gpuFrameNum*: uint32
    numDynamicIndexBuffers*: uint16
    numDynamicVertexBuffers*: uint16
    numFrameBuffers*: uint16
    numIndexBuffers*: uint16
    numOcclusionQueries*: uint16
    numPrograms*: uint16
    numShaders*: uint16
    numTextures*: uint16
    numUniforms*: uint16
    numVertexBuffers*: uint16
    numVertexLayouts*: uint16
    textureMemoryUsed*: int64
    rtMemoryUsed*: int64
    transientVbUsed*: int32
    transientIbUsed*: int32
    numPrims*: array[5, uint32]
    gpuMemoryMax*: int64
    gpuMemoryUsed*: int64
    width*: uint16
    height*: uint16
    textWidth*: uint16
    textHeight*: uint16
    numViews*: uint16
    viewStats*: ptr bgfx_view_stats_t
    numEncoders*: uint8
    encoderStats*: ptr bgfx_encoder_stats_t
  bgfx_vertex_layout_s* {.importc: "bgfx_vertex_layout_t", header: "bgfx/c99/bgfx.h", completeStruct, bycopy.} = object
    hash*: uint32
    stride*: uint16
    offset*: array[26, uint16]
    attributes*: array[26, uint16]
  bgfx_encoder_s* {.importc: "bgfx_encoder_t", header: "bgfx/c99/bgfx.h", incompleteStruct.} = object
  bgfx_fatal* {.importc: "bgfx_fatal_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_FATAL_DEBUG_CHECK = 0
    BGFX_FATAL_INVALID_SHADER = 1
    BGFX_FATAL_UNABLE_TO_INITIALIZE = 2
    BGFX_FATAL_UNABLE_TO_CREATE_TEXTURE = 3
    BGFX_FATAL_DEVICE_LOST = 4
    BGFX_FATAL_COUNT = 5
  bgfx_fatal_t* = bgfx_fatal
  bgfx_renderer_type* {.importc: "bgfx_renderer_type_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_RENDERER_TYPE_NOOP = 0
    BGFX_RENDERER_TYPE_AGC = 1
    BGFX_RENDERER_TYPE_DIRECT3D11 = 2
    BGFX_RENDERER_TYPE_DIRECT3D12 = 3
    BGFX_RENDERER_TYPE_GNM = 4
    BGFX_RENDERER_TYPE_METAL = 5
    BGFX_RENDERER_TYPE_NVN = 6
    BGFX_RENDERER_TYPE_OPENGLES = 7
    BGFX_RENDERER_TYPE_OPENGL = 8
    BGFX_RENDERER_TYPE_VULKAN = 9
    BGFX_RENDERER_TYPE_WEBGPU = 10
    BGFX_RENDERER_TYPE_COUNT = 11
  bgfx_renderer_type_t* = bgfx_renderer_type
  bgfx_access* {.importc: "bgfx_access_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_ACCESS_READ = 0
    BGFX_ACCESS_WRITE = 1
    BGFX_ACCESS_READWRITE = 2
    BGFX_ACCESS_COUNT = 3
  bgfx_access_t* = bgfx_access
  bgfx_attrib* {.importc: "bgfx_attrib_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_ATTRIB_POSITION = 0
    BGFX_ATTRIB_NORMAL = 1
    BGFX_ATTRIB_TANGENT = 2
    BGFX_ATTRIB_BITANGENT = 3
    BGFX_ATTRIB_COLOR0 = 4
    BGFX_ATTRIB_COLOR1 = 5
    BGFX_ATTRIB_COLOR2 = 6
    BGFX_ATTRIB_COLOR3 = 7
    BGFX_ATTRIB_INDICES = 8
    BGFX_ATTRIB_WEIGHT = 9
    BGFX_ATTRIB_TEXCOORD0 = 10
    BGFX_ATTRIB_TEXCOORD1 = 11
    BGFX_ATTRIB_TEXCOORD2 = 12
    BGFX_ATTRIB_TEXCOORD3 = 13
    BGFX_ATTRIB_TEXCOORD4 = 14
    BGFX_ATTRIB_TEXCOORD5 = 15
    BGFX_ATTRIB_TEXCOORD6 = 16
    BGFX_ATTRIB_TEXCOORD7 = 17
    BGFX_ATTRIB_TEXCOORD8 = 18
    BGFX_ATTRIB_TEXCOORD9 = 19
    BGFX_ATTRIB_TEXCOORD10 = 20
    BGFX_ATTRIB_TEXCOORD11 = 21
    BGFX_ATTRIB_TEXCOORD12 = 22
    BGFX_ATTRIB_TEXCOORD13 = 23
    BGFX_ATTRIB_TEXCOORD14 = 24
    BGFX_ATTRIB_TEXCOORD15 = 25
    BGFX_ATTRIB_COUNT = 26
  bgfx_attrib_t* = bgfx_attrib
  bgfx_attrib_type* {.importc: "bgfx_attrib_type_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_ATTRIB_TYPE_INT8 = 0
    BGFX_ATTRIB_TYPE_UINT8 = 1
    BGFX_ATTRIB_TYPE_UINT10 = 2
    BGFX_ATTRIB_TYPE_INT16 = 3
    BGFX_ATTRIB_TYPE_UINT16 = 4
    BGFX_ATTRIB_TYPE_HALF = 5
    BGFX_ATTRIB_TYPE_FLOAT = 6
    BGFX_ATTRIB_TYPE_INT32 = 7
    BGFX_ATTRIB_TYPE_UINT32 = 8
    BGFX_ATTRIB_TYPE_COUNT = 9
  bgfx_attrib_type_t* = bgfx_attrib_type
  bgfx_texture_format* {.importc: "bgfx_texture_format_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_TEXTURE_FORMAT_BC1 = 0
    BGFX_TEXTURE_FORMAT_BC2 = 1
    BGFX_TEXTURE_FORMAT_BC3 = 2
    BGFX_TEXTURE_FORMAT_BC4 = 3
    BGFX_TEXTURE_FORMAT_BC4S = 4
    BGFX_TEXTURE_FORMAT_BC5 = 5
    BGFX_TEXTURE_FORMAT_BC5S = 6
    BGFX_TEXTURE_FORMAT_BC6H = 7
    BGFX_TEXTURE_FORMAT_BC6HU = 8
    BGFX_TEXTURE_FORMAT_BC7 = 9
    BGFX_TEXTURE_FORMAT_ETC1 = 10
    BGFX_TEXTURE_FORMAT_ETC2 = 11
    BGFX_TEXTURE_FORMAT_ETC2A = 12
    BGFX_TEXTURE_FORMAT_ETC2A1 = 13
    BGFX_TEXTURE_FORMAT_EACR11 = 14
    BGFX_TEXTURE_FORMAT_EACR11S = 15
    BGFX_TEXTURE_FORMAT_EACRG11 = 16
    BGFX_TEXTURE_FORMAT_EACRG11S = 17
    BGFX_TEXTURE_FORMAT_PTC12 = 18
    BGFX_TEXTURE_FORMAT_PTC14 = 19
    BGFX_TEXTURE_FORMAT_PTC12A = 20
    BGFX_TEXTURE_FORMAT_PTC14A = 21
    BGFX_TEXTURE_FORMAT_PTC22 = 22
    BGFX_TEXTURE_FORMAT_PTC24 = 23
    BGFX_TEXTURE_FORMAT_ATC = 24
    BGFX_TEXTURE_FORMAT_ATCE = 25
    BGFX_TEXTURE_FORMAT_ATCI = 26
    BGFX_TEXTURE_FORMAT_ASTC4X4 = 27
    BGFX_TEXTURE_FORMAT_ASTC5X4 = 28
    BGFX_TEXTURE_FORMAT_ASTC5X5 = 29
    BGFX_TEXTURE_FORMAT_ASTC6X5 = 30
    BGFX_TEXTURE_FORMAT_ASTC6X6 = 31
    BGFX_TEXTURE_FORMAT_ASTC8X5 = 32
    BGFX_TEXTURE_FORMAT_ASTC8X6 = 33
    BGFX_TEXTURE_FORMAT_ASTC8X8 = 34
    BGFX_TEXTURE_FORMAT_ASTC10X5 = 35
    BGFX_TEXTURE_FORMAT_ASTC10X6 = 36
    BGFX_TEXTURE_FORMAT_ASTC10X8 = 37
    BGFX_TEXTURE_FORMAT_ASTC10X10 = 38
    BGFX_TEXTURE_FORMAT_ASTC12X10 = 39
    BGFX_TEXTURE_FORMAT_ASTC12X12 = 40
    BGFX_TEXTURE_FORMAT_UNKNOWN = 41
    BGFX_TEXTURE_FORMAT_R1 = 42
    BGFX_TEXTURE_FORMAT_A8 = 43
    BGFX_TEXTURE_FORMAT_R8 = 44
    BGFX_TEXTURE_FORMAT_R8I = 45
    BGFX_TEXTURE_FORMAT_R8U = 46
    BGFX_TEXTURE_FORMAT_R8S = 47
    BGFX_TEXTURE_FORMAT_R16 = 48
    BGFX_TEXTURE_FORMAT_R16I = 49
    BGFX_TEXTURE_FORMAT_R16U = 50
    BGFX_TEXTURE_FORMAT_R16F = 51
    BGFX_TEXTURE_FORMAT_R16S = 52
    BGFX_TEXTURE_FORMAT_R32I = 53
    BGFX_TEXTURE_FORMAT_R32U = 54
    BGFX_TEXTURE_FORMAT_R32F = 55
    BGFX_TEXTURE_FORMAT_RG8 = 56
    BGFX_TEXTURE_FORMAT_RG8I = 57
    BGFX_TEXTURE_FORMAT_RG8U = 58
    BGFX_TEXTURE_FORMAT_RG8S = 59
    BGFX_TEXTURE_FORMAT_RG16 = 60
    BGFX_TEXTURE_FORMAT_RG16I = 61
    BGFX_TEXTURE_FORMAT_RG16U = 62
    BGFX_TEXTURE_FORMAT_RG16F = 63
    BGFX_TEXTURE_FORMAT_RG16S = 64
    BGFX_TEXTURE_FORMAT_RG32I = 65
    BGFX_TEXTURE_FORMAT_RG32U = 66
    BGFX_TEXTURE_FORMAT_RG32F = 67
    BGFX_TEXTURE_FORMAT_RGB8 = 68
    BGFX_TEXTURE_FORMAT_RGB8I = 69
    BGFX_TEXTURE_FORMAT_RGB8U = 70
    BGFX_TEXTURE_FORMAT_RGB8S = 71
    BGFX_TEXTURE_FORMAT_RGB9E5F = 72
    BGFX_TEXTURE_FORMAT_BGRA8 = 73
    BGFX_TEXTURE_FORMAT_RGBA8 = 74
    BGFX_TEXTURE_FORMAT_RGBA8I = 75
    BGFX_TEXTURE_FORMAT_RGBA8U = 76
    BGFX_TEXTURE_FORMAT_RGBA8S = 77
    BGFX_TEXTURE_FORMAT_RGBA16 = 78
    BGFX_TEXTURE_FORMAT_RGBA16I = 79
    BGFX_TEXTURE_FORMAT_RGBA16U = 80
    BGFX_TEXTURE_FORMAT_RGBA16F = 81
    BGFX_TEXTURE_FORMAT_RGBA16S = 82
    BGFX_TEXTURE_FORMAT_RGBA32I = 83
    BGFX_TEXTURE_FORMAT_RGBA32U = 84
    BGFX_TEXTURE_FORMAT_RGBA32F = 85
    BGFX_TEXTURE_FORMAT_B5G6R5 = 86
    BGFX_TEXTURE_FORMAT_R5G6B5 = 87
    BGFX_TEXTURE_FORMAT_BGRA4 = 88
    BGFX_TEXTURE_FORMAT_RGBA4 = 89
    BGFX_TEXTURE_FORMAT_BGR5A1 = 90
    BGFX_TEXTURE_FORMAT_RGB5A1 = 91
    BGFX_TEXTURE_FORMAT_RGB10A2 = 92
    BGFX_TEXTURE_FORMAT_RGB10A2U = 93
    BGFX_TEXTURE_FORMAT_RG11B10F = 94
    BGFX_TEXTURE_FORMAT_UNKNOWNDEPTH = 95
    BGFX_TEXTURE_FORMAT_D16 = 96
    BGFX_TEXTURE_FORMAT_D24 = 97
    BGFX_TEXTURE_FORMAT_D24S8 = 98
    BGFX_TEXTURE_FORMAT_D32 = 99
    BGFX_TEXTURE_FORMAT_D16F = 100
    BGFX_TEXTURE_FORMAT_D24F = 101
    BGFX_TEXTURE_FORMAT_D32F = 102
    BGFX_TEXTURE_FORMAT_D32FS8 = 103
    BGFX_TEXTURE_FORMAT_D0S8 = 104
    BGFX_TEXTURE_FORMAT_COUNT = 105
  bgfx_texture_format_t* = bgfx_texture_format
  bgfx_uniform_type* {.importc: "bgfx_uniform_type_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_UNIFORM_TYPE_SAMPLER = 0
    BGFX_UNIFORM_TYPE_END = 1
    BGFX_UNIFORM_TYPE_VEC4 = 2
    BGFX_UNIFORM_TYPE_MAT3 = 3
    BGFX_UNIFORM_TYPE_MAT4 = 4
    BGFX_UNIFORM_TYPE_COUNT = 5
  bgfx_uniform_type_t* = bgfx_uniform_type
  bgfx_uniform_freq* {.importc: "bgfx_uniform_freq_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_UNIFORM_FREQ_DRAW = 0
    BGFX_UNIFORM_FREQ_VIEW = 1
    BGFX_UNIFORM_FREQ_FRAME = 2
    BGFX_UNIFORM_FREQ_COUNT = 3
  bgfx_uniform_freq_t* = bgfx_uniform_freq
  bgfx_backbuffer_ratio* {.importc: "bgfx_backbuffer_ratio_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_BACKBUFFER_RATIO_EQUAL = 0
    BGFX_BACKBUFFER_RATIO_HALF = 1
    BGFX_BACKBUFFER_RATIO_QUARTER = 2
    BGFX_BACKBUFFER_RATIO_EIGHTH = 3
    BGFX_BACKBUFFER_RATIO_SIXTEENTH = 4
    BGFX_BACKBUFFER_RATIO_DOUBLE = 5
    BGFX_BACKBUFFER_RATIO_COUNT = 6
  bgfx_backbuffer_ratio_t* = bgfx_backbuffer_ratio
  bgfx_occlusion_query_result* {.importc: "bgfx_occlusion_query_result_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_OCCLUSION_QUERY_RESULT_INVISIBLE = 0
    BGFX_OCCLUSION_QUERY_RESULT_VISIBLE = 1
    BGFX_OCCLUSION_QUERY_RESULT_NORESULT = 2
    BGFX_OCCLUSION_QUERY_RESULT_COUNT = 3
  bgfx_occlusion_query_result_t* = bgfx_occlusion_query_result
  bgfx_video_codec* {.importc: "bgfx_video_codec_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_VIDEO_CODEC_H264 = 0
    BGFX_VIDEO_CODEC_H265 = 1
    BGFX_VIDEO_CODEC_AV1 = 2
    BGFX_VIDEO_CODEC_COUNT = 3
  bgfx_video_codec_t* = bgfx_video_codec
  bgfx_topology* {.importc: "bgfx_topology_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_TOPOLOGY_TRI_LIST = 0
    BGFX_TOPOLOGY_TRI_STRIP = 1
    BGFX_TOPOLOGY_LINE_LIST = 2
    BGFX_TOPOLOGY_LINE_STRIP = 3
    BGFX_TOPOLOGY_POINT_LIST = 4
    BGFX_TOPOLOGY_COUNT = 5
  bgfx_topology_t* = bgfx_topology
  bgfx_topology_convert* {.importc: "bgfx_topology_convert_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_TOPOLOGY_CONVERT_TRI_LIST_FLIP_WINDING = 0
    BGFX_TOPOLOGY_CONVERT_TRI_STRIP_FLIP_WINDING = 1
    BGFX_TOPOLOGY_CONVERT_TRI_LIST_TO_LINE_LIST = 2
    BGFX_TOPOLOGY_CONVERT_TRI_STRIP_TO_TRI_LIST = 3
    BGFX_TOPOLOGY_CONVERT_LINE_STRIP_TO_LINE_LIST = 4
    BGFX_TOPOLOGY_CONVERT_COUNT = 5
  bgfx_topology_convert_t* = bgfx_topology_convert
  bgfx_topology_sort* {.importc: "bgfx_topology_sort_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_TOPOLOGY_SORT_DIRECTION_FRONT_TO_BACK_MIN = 0
    BGFX_TOPOLOGY_SORT_DIRECTION_FRONT_TO_BACK_AVG = 1
    BGFX_TOPOLOGY_SORT_DIRECTION_FRONT_TO_BACK_MAX = 2
    BGFX_TOPOLOGY_SORT_DIRECTION_BACK_TO_FRONT_MIN = 3
    BGFX_TOPOLOGY_SORT_DIRECTION_BACK_TO_FRONT_AVG = 4
    BGFX_TOPOLOGY_SORT_DIRECTION_BACK_TO_FRONT_MAX = 5
    BGFX_TOPOLOGY_SORT_DISTANCE_FRONT_TO_BACK_MIN = 6
    BGFX_TOPOLOGY_SORT_DISTANCE_FRONT_TO_BACK_AVG = 7
    BGFX_TOPOLOGY_SORT_DISTANCE_FRONT_TO_BACK_MAX = 8
    BGFX_TOPOLOGY_SORT_DISTANCE_BACK_TO_FRONT_MIN = 9
    BGFX_TOPOLOGY_SORT_DISTANCE_BACK_TO_FRONT_AVG = 10
    BGFX_TOPOLOGY_SORT_DISTANCE_BACK_TO_FRONT_MAX = 11
    BGFX_TOPOLOGY_SORT_COUNT = 12
  bgfx_topology_sort_t* = bgfx_topology_sort
  bgfx_view_mode* {.importc: "bgfx_view_mode_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_VIEW_MODE_DEFAULT = 0
    BGFX_VIEW_MODE_SEQUENTIAL = 1
    BGFX_VIEW_MODE_DEPTH_ASCENDING = 2
    BGFX_VIEW_MODE_DEPTH_DESCENDING = 3
    BGFX_VIEW_MODE_COUNT = 4
  bgfx_view_mode_t* = bgfx_view_mode
  bgfx_shading_rate* {.importc: "bgfx_shading_rate_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_SHADING_RATE_RATE_1X_1 = 0
    BGFX_SHADING_RATE_RATE_1X_2 = 1
    BGFX_SHADING_RATE_RATE_2X_1 = 2
    BGFX_SHADING_RATE_RATE_2X_2 = 3
    BGFX_SHADING_RATE_RATE_2X_4 = 4
    BGFX_SHADING_RATE_RATE_4X_2 = 5
    BGFX_SHADING_RATE_RATE_4X_4 = 6
    BGFX_SHADING_RATE_COUNT = 7
  bgfx_shading_rate_t* = bgfx_shading_rate
  bgfx_native_window_handle_type* {.importc: "bgfx_native_window_handle_type_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_NATIVE_WINDOW_HANDLE_TYPE_DEFAULT = 0
    BGFX_NATIVE_WINDOW_HANDLE_TYPE_WAYLAND = 1
    BGFX_NATIVE_WINDOW_HANDLE_TYPE_COUNT = 2
  bgfx_native_window_handle_type_t* = bgfx_native_window_handle_type
  bgfx_render_frame* {.importc: "bgfx_render_frame_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_RENDER_FRAME_NO_CONTEXT = 0
    BGFX_RENDER_FRAME_RENDER = 1
    BGFX_RENDER_FRAME_TIMEOUT = 2
    BGFX_RENDER_FRAME_EXITING = 3
    BGFX_RENDER_FRAME_COUNT = 4
  bgfx_render_frame_t* = bgfx_render_frame
  bgfx_view_id_t* = uint16
  bgfx_allocator_interface_t* = bgfx_allocator_interface_s
  bgfx_allocator_vtbl_t* = bgfx_allocator_vtbl_s
  bgfx_interface_vtbl_t* = bgfx_interface_vtbl
  bgfx_callback_interface_t* = bgfx_callback_interface_s
  bgfx_callback_vtbl_t* = bgfx_callback_vtbl_s
  bgfx_dynamic_index_buffer_handle_t* = bgfx_dynamic_index_buffer_handle_s
  bgfx_dynamic_vertex_buffer_handle_t* = bgfx_dynamic_vertex_buffer_handle_s
  bgfx_frame_buffer_handle_t* = bgfx_frame_buffer_handle_s
  bgfx_index_buffer_handle_t* = bgfx_index_buffer_handle_s
  bgfx_indirect_buffer_handle_t* = bgfx_indirect_buffer_handle_s
  bgfx_occlusion_query_handle_t* = bgfx_occlusion_query_handle_s
  bgfx_program_handle_t* = bgfx_program_handle_s
  bgfx_shader_handle_t* = bgfx_shader_handle_s
  bgfx_texture_handle_t* = bgfx_texture_handle_s
  bgfx_uniform_handle_t* = bgfx_uniform_handle_s
  bgfx_vertex_buffer_handle_t* = bgfx_vertex_buffer_handle_s
  bgfx_vertex_layout_handle_t* = bgfx_vertex_layout_handle_s
  bgfx_release_fn_t* = proc(p0: pointer; p1: pointer) {.cdecl.}
  bgfx_caps_gpu_t* = bgfx_caps_gpu_s
  bgfx_caps_limits_t* = bgfx_caps_limits_s
  bgfx_caps_t* = bgfx_caps_s
  bgfx_internal_data_t* = bgfx_internal_data_s
  bgfx_platform_data_t* = bgfx_platform_data_s
  bgfx_resolution_t* = bgfx_resolution_s
  bgfx_init_limits_t* = bgfx_init_limits_s
  bgfx_init_t* = bgfx_init_s
  bgfx_memory_t* = bgfx_memory_s
  bgfx_transient_index_buffer_t* = bgfx_transient_index_buffer_s
  bgfx_transient_vertex_buffer_t* = bgfx_transient_vertex_buffer_s
  bgfx_instance_data_buffer_t* = bgfx_instance_data_buffer_s
  bgfx_texture_info_t* = bgfx_texture_info_s
  bgfx_video_decoder_init_t* = bgfx_video_decoder_init_s
  bgfx_video_decoder_au_t* = bgfx_video_decoder_au_s
  bgfx_video_decoder_frame_t* = bgfx_video_decoder_frame_s
  bgfx_uniform_info_t* = bgfx_uniform_info_s
  bgfx_attachment_t* = bgfx_attachment_s
  bgfx_transform_t* = bgfx_transform_s
  bgfx_view_stats_t* = bgfx_view_stats_s
  bgfx_encoder_stats_t* = bgfx_encoder_stats_s
  bgfx_stats_t* = bgfx_stats_s
  bgfx_vertex_layout_t* = bgfx_vertex_layout_s
  bgfx_encoder_t* = bgfx_encoder_s
  bgfx_function_id* {.importc: "bgfx_function_id_t", header: "bgfx/c99/bgfx.h", pure, size: sizeof(cint).} = enum
    BGFX_FUNCTION_ID_ATTACHMENT_INIT = 0
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_BEGIN = 1
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_ADD = 2
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_DECODE = 3
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_HAS = 4
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_SKIP = 5
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_END = 6
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_GET_OFFSET = 7
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_GET_STRIDE = 8
    BGFX_FUNCTION_ID_VERTEX_LAYOUT_GET_SIZE = 9
    BGFX_FUNCTION_ID_VERTEX_PACK = 10
    BGFX_FUNCTION_ID_VERTEX_UNPACK = 11
    BGFX_FUNCTION_ID_VERTEX_CONVERT = 12
    BGFX_FUNCTION_ID_TOPOLOGY_CONVERT = 13
    BGFX_FUNCTION_ID_TOPOLOGY_SORT_TRI_LIST = 14
    BGFX_FUNCTION_ID_GET_SUPPORTED_RENDERERS = 15
    BGFX_FUNCTION_ID_GET_RENDERER_NAME = 16
    BGFX_FUNCTION_ID_INIT_CTOR = 17
    BGFX_FUNCTION_ID_INIT = 18
    BGFX_FUNCTION_ID_SHUTDOWN = 19
    BGFX_FUNCTION_ID_RESET = 20
    BGFX_FUNCTION_ID_FRAME = 21
    BGFX_FUNCTION_ID_GET_RENDERER_TYPE = 22
    BGFX_FUNCTION_ID_GET_CAPS = 23
    BGFX_FUNCTION_ID_GET_STATS = 24
    BGFX_FUNCTION_ID_ALLOC = 25
    BGFX_FUNCTION_ID_COPY = 26
    BGFX_FUNCTION_ID_MAKE_REF = 27
    BGFX_FUNCTION_ID_MAKE_REF_RELEASE = 28
    BGFX_FUNCTION_ID_SET_DEBUG = 29
    BGFX_FUNCTION_ID_DBG_TEXT_CLEAR = 30
    BGFX_FUNCTION_ID_DBG_TEXT_PRINTF = 31
    BGFX_FUNCTION_ID_DBG_TEXT_VPRINTF = 32
    BGFX_FUNCTION_ID_DBG_TEXT_IMAGE = 33
    BGFX_FUNCTION_ID_CREATE_INDEX_BUFFER = 34
    BGFX_FUNCTION_ID_SET_INDEX_BUFFER_NAME = 35
    BGFX_FUNCTION_ID_DESTROY_INDEX_BUFFER = 36
    BGFX_FUNCTION_ID_CREATE_VERTEX_LAYOUT = 37
    BGFX_FUNCTION_ID_DESTROY_VERTEX_LAYOUT = 38
    BGFX_FUNCTION_ID_CREATE_VERTEX_BUFFER = 39
    BGFX_FUNCTION_ID_SET_VERTEX_BUFFER_NAME = 40
    BGFX_FUNCTION_ID_DESTROY_VERTEX_BUFFER = 41
    BGFX_FUNCTION_ID_CREATE_DYNAMIC_INDEX_BUFFER = 42
    BGFX_FUNCTION_ID_CREATE_DYNAMIC_INDEX_BUFFER_MEM = 43
    BGFX_FUNCTION_ID_UPDATE_DYNAMIC_INDEX_BUFFER = 44
    BGFX_FUNCTION_ID_DESTROY_DYNAMIC_INDEX_BUFFER = 45
    BGFX_FUNCTION_ID_CREATE_DYNAMIC_VERTEX_BUFFER = 46
    BGFX_FUNCTION_ID_CREATE_DYNAMIC_VERTEX_BUFFER_MEM = 47
    BGFX_FUNCTION_ID_UPDATE_DYNAMIC_VERTEX_BUFFER = 48
    BGFX_FUNCTION_ID_DESTROY_DYNAMIC_VERTEX_BUFFER = 49
    BGFX_FUNCTION_ID_GET_AVAIL_TRANSIENT_INDEX_BUFFER = 50
    BGFX_FUNCTION_ID_GET_AVAIL_TRANSIENT_VERTEX_BUFFER = 51
    BGFX_FUNCTION_ID_GET_AVAIL_INSTANCE_DATA_BUFFER = 52
    BGFX_FUNCTION_ID_ALLOC_TRANSIENT_INDEX_BUFFER = 53
    BGFX_FUNCTION_ID_ALLOC_TRANSIENT_VERTEX_BUFFER = 54
    BGFX_FUNCTION_ID_ALLOC_TRANSIENT_BUFFERS = 55
    BGFX_FUNCTION_ID_ALLOC_INSTANCE_DATA_BUFFER = 56
    BGFX_FUNCTION_ID_CREATE_INDIRECT_BUFFER = 57
    BGFX_FUNCTION_ID_DESTROY_INDIRECT_BUFFER = 58
    BGFX_FUNCTION_ID_CREATE_SHADER = 59
    BGFX_FUNCTION_ID_GET_SHADER_UNIFORMS = 60
    BGFX_FUNCTION_ID_SET_SHADER_NAME = 61
    BGFX_FUNCTION_ID_DESTROY_SHADER = 62
    BGFX_FUNCTION_ID_CREATE_PROGRAM = 63
    BGFX_FUNCTION_ID_CREATE_COMPUTE_PROGRAM = 64
    BGFX_FUNCTION_ID_DESTROY_PROGRAM = 65
    BGFX_FUNCTION_ID_IS_TEXTURE_VALID = 66
    BGFX_FUNCTION_ID_IS_VIDEO_CODEC_VALID = 67
    BGFX_FUNCTION_ID_IS_FRAME_BUFFER_VALID = 68
    BGFX_FUNCTION_ID_CALC_TEXTURE_SIZE = 69
    BGFX_FUNCTION_ID_CREATE_TEXTURE = 70
    BGFX_FUNCTION_ID_CREATE_TEXTURE_2D = 71
    BGFX_FUNCTION_ID_CREATE_TEXTURE_2D_SCALED = 72
    BGFX_FUNCTION_ID_CREATE_TEXTURE_3D = 73
    BGFX_FUNCTION_ID_CREATE_TEXTURE_CUBE = 74
    BGFX_FUNCTION_ID_UPDATE_TEXTURE_2D = 75
    BGFX_FUNCTION_ID_UPDATE_TEXTURE_3D = 76
    BGFX_FUNCTION_ID_UPDATE_TEXTURE_CUBE = 77
    BGFX_FUNCTION_ID_CLEAR_TEXTURE = 78
    BGFX_FUNCTION_ID_READ_TEXTURE = 79
    BGFX_FUNCTION_ID_SET_TEXTURE_NAME = 80
    BGFX_FUNCTION_ID_GET_DIRECT_ACCESS_PTR = 81
    BGFX_FUNCTION_ID_DESTROY_TEXTURE = 82
    BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER = 83
    BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_SCALED = 84
    BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_FROM_HANDLES = 85
    BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_FROM_ATTACHMENT = 86
    BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_FROM_NWH = 87
    BGFX_FUNCTION_ID_SET_FRAME_BUFFER_NAME = 88
    BGFX_FUNCTION_ID_GET_TEXTURE = 89
    BGFX_FUNCTION_ID_DESTROY_FRAME_BUFFER = 90
    BGFX_FUNCTION_ID_CREATE_UNIFORM = 91
    BGFX_FUNCTION_ID_CREATE_UNIFORM_WITH_FREQ = 92
    BGFX_FUNCTION_ID_GET_UNIFORM_INFO = 93
    BGFX_FUNCTION_ID_DESTROY_UNIFORM = 94
    BGFX_FUNCTION_ID_CREATE_OCCLUSION_QUERY = 95
    BGFX_FUNCTION_ID_GET_RESULT = 96
    BGFX_FUNCTION_ID_DESTROY_OCCLUSION_QUERY = 97
    BGFX_FUNCTION_ID_SET_PALETTE_COLOR = 98
    BGFX_FUNCTION_ID_SET_PALETTE_COLOR_RGBA32F = 99
    BGFX_FUNCTION_ID_SET_PALETTE_COLOR_RGBA8 = 100
    BGFX_FUNCTION_ID_SET_VIEW_NAME = 101
    BGFX_FUNCTION_ID_SET_VIEW_RECT = 102
    BGFX_FUNCTION_ID_SET_VIEW_RECT_RATIO = 103
    BGFX_FUNCTION_ID_SET_VIEW_SCISSOR = 104
    BGFX_FUNCTION_ID_SET_VIEW_CLEAR = 105
    BGFX_FUNCTION_ID_SET_VIEW_CLEAR_MRT = 106
    BGFX_FUNCTION_ID_SET_VIEW_MODE = 107
    BGFX_FUNCTION_ID_SET_VIEW_FRAME_BUFFER = 108
    BGFX_FUNCTION_ID_SET_VIEW_TRANSFORM = 109
    BGFX_FUNCTION_ID_SET_VIEW_ORDER = 110
    BGFX_FUNCTION_ID_SET_VIEW_SHADING_RATE = 111
    BGFX_FUNCTION_ID_RESET_VIEW = 112
    BGFX_FUNCTION_ID_ENCODER_BEGIN = 113
    BGFX_FUNCTION_ID_ENCODER_END = 114
    BGFX_FUNCTION_ID_ENCODER_SET_MARKER = 115
    BGFX_FUNCTION_ID_ENCODER_SET_STATE = 116
    BGFX_FUNCTION_ID_ENCODER_SET_CONDITION = 117
    BGFX_FUNCTION_ID_ENCODER_SET_STENCIL = 118
    BGFX_FUNCTION_ID_ENCODER_SET_SCISSOR = 119
    BGFX_FUNCTION_ID_ENCODER_SET_SCISSOR_CACHED = 120
    BGFX_FUNCTION_ID_ENCODER_SET_TRANSFORM = 121
    BGFX_FUNCTION_ID_ENCODER_SET_TRANSFORM_CACHED = 122
    BGFX_FUNCTION_ID_ENCODER_ALLOC_TRANSFORM = 123
    BGFX_FUNCTION_ID_ENCODER_SET_UNIFORM = 124
    BGFX_FUNCTION_ID_SET_VIEW_UNIFORM = 125
    BGFX_FUNCTION_ID_SET_FRAME_UNIFORM = 126
    BGFX_FUNCTION_ID_ENCODER_SET_INDEX_BUFFER = 127
    BGFX_FUNCTION_ID_ENCODER_SET_DYNAMIC_INDEX_BUFFER = 128
    BGFX_FUNCTION_ID_ENCODER_SET_TRANSIENT_INDEX_BUFFER = 129
    BGFX_FUNCTION_ID_ENCODER_SET_VERTEX_BUFFER = 130
    BGFX_FUNCTION_ID_ENCODER_SET_VERTEX_BUFFER_WITH_LAYOUT = 131
    BGFX_FUNCTION_ID_ENCODER_SET_DYNAMIC_VERTEX_BUFFER = 132
    BGFX_FUNCTION_ID_ENCODER_SET_DYNAMIC_VERTEX_BUFFER_WITH_LAYOUT = 133
    BGFX_FUNCTION_ID_ENCODER_SET_TRANSIENT_VERTEX_BUFFER = 134
    BGFX_FUNCTION_ID_ENCODER_SET_TRANSIENT_VERTEX_BUFFER_WITH_LAYOUT = 135
    BGFX_FUNCTION_ID_ENCODER_SET_VERTEX_COUNT = 136
    BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_DATA_BUFFER = 137
    BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_DATA_FROM_VERTEX_BUFFER = 138
    BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_DATA_FROM_DYNAMIC_VERTEX_BUFFER = 139
    BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_COUNT = 140
    BGFX_FUNCTION_ID_ENCODER_SET_TEXTURE = 141
    BGFX_FUNCTION_ID_ENCODER_SET_TEXTURE_VIEW = 142
    BGFX_FUNCTION_ID_ENCODER_TOUCH = 143
    BGFX_FUNCTION_ID_ENCODER_SUBMIT = 144
    BGFX_FUNCTION_ID_ENCODER_SUBMIT_OCCLUSION_QUERY = 145
    BGFX_FUNCTION_ID_ENCODER_SUBMIT_INDIRECT = 146
    BGFX_FUNCTION_ID_ENCODER_SUBMIT_INDIRECT_COUNT = 147
    BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_INDEX_BUFFER = 148
    BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_VERTEX_BUFFER = 149
    BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_DYNAMIC_INDEX_BUFFER = 150
    BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_DYNAMIC_VERTEX_BUFFER = 151
    BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_INDIRECT_BUFFER = 152
    BGFX_FUNCTION_ID_ENCODER_SET_IMAGE = 153
    BGFX_FUNCTION_ID_ENCODER_SET_IMAGE_VIEW = 154
    BGFX_FUNCTION_ID_ENCODER_DISPATCH = 155
    BGFX_FUNCTION_ID_ENCODER_DISPATCH_INDIRECT = 156
    BGFX_FUNCTION_ID_ENCODER_DISCARD = 157
    BGFX_FUNCTION_ID_ENCODER_BLIT = 158
    BGFX_FUNCTION_ID_REQUEST_SCREEN_SHOT = 159
    BGFX_FUNCTION_ID_RENDER_FRAME = 160
    BGFX_FUNCTION_ID_SET_PLATFORM_DATA = 161
    BGFX_FUNCTION_ID_GET_INTERNAL_DATA = 162
    BGFX_FUNCTION_ID_OVERRIDE_INTERNAL_TEXTURE_PTR = 163
    BGFX_FUNCTION_ID_OVERRIDE_INTERNAL_TEXTURE = 164
    BGFX_FUNCTION_ID_SET_MARKER = 165
    BGFX_FUNCTION_ID_SET_STATE = 166
    BGFX_FUNCTION_ID_SET_CONDITION = 167
    BGFX_FUNCTION_ID_SET_STENCIL = 168
    BGFX_FUNCTION_ID_SET_SCISSOR = 169
    BGFX_FUNCTION_ID_SET_SCISSOR_CACHED = 170
    BGFX_FUNCTION_ID_SET_TRANSFORM = 171
    BGFX_FUNCTION_ID_SET_TRANSFORM_CACHED = 172
    BGFX_FUNCTION_ID_ALLOC_TRANSFORM = 173
    BGFX_FUNCTION_ID_SET_UNIFORM = 174
    BGFX_FUNCTION_ID_SET_INDEX_BUFFER = 175
    BGFX_FUNCTION_ID_SET_DYNAMIC_INDEX_BUFFER = 176
    BGFX_FUNCTION_ID_SET_TRANSIENT_INDEX_BUFFER = 177
    BGFX_FUNCTION_ID_SET_VERTEX_BUFFER = 178
    BGFX_FUNCTION_ID_SET_VERTEX_BUFFER_WITH_LAYOUT = 179
    BGFX_FUNCTION_ID_SET_DYNAMIC_VERTEX_BUFFER = 180
    BGFX_FUNCTION_ID_SET_DYNAMIC_VERTEX_BUFFER_WITH_LAYOUT = 181
    BGFX_FUNCTION_ID_SET_TRANSIENT_VERTEX_BUFFER = 182
    BGFX_FUNCTION_ID_SET_TRANSIENT_VERTEX_BUFFER_WITH_LAYOUT = 183
    BGFX_FUNCTION_ID_SET_VERTEX_COUNT = 184
    BGFX_FUNCTION_ID_SET_INSTANCE_DATA_BUFFER = 185
    BGFX_FUNCTION_ID_SET_INSTANCE_DATA_FROM_VERTEX_BUFFER = 186
    BGFX_FUNCTION_ID_SET_INSTANCE_DATA_FROM_DYNAMIC_VERTEX_BUFFER = 187
    BGFX_FUNCTION_ID_SET_INSTANCE_COUNT = 188
    BGFX_FUNCTION_ID_SET_TEXTURE = 189
    BGFX_FUNCTION_ID_SET_TEXTURE_VIEW = 190
    BGFX_FUNCTION_ID_TOUCH = 191
    BGFX_FUNCTION_ID_SUBMIT = 192
    BGFX_FUNCTION_ID_SUBMIT_OCCLUSION_QUERY = 193
    BGFX_FUNCTION_ID_SUBMIT_INDIRECT = 194
    BGFX_FUNCTION_ID_SUBMIT_INDIRECT_COUNT = 195
    BGFX_FUNCTION_ID_SET_COMPUTE_INDEX_BUFFER = 196
    BGFX_FUNCTION_ID_SET_COMPUTE_VERTEX_BUFFER = 197
    BGFX_FUNCTION_ID_SET_COMPUTE_DYNAMIC_INDEX_BUFFER = 198
    BGFX_FUNCTION_ID_SET_COMPUTE_DYNAMIC_VERTEX_BUFFER = 199
    BGFX_FUNCTION_ID_SET_COMPUTE_INDIRECT_BUFFER = 200
    BGFX_FUNCTION_ID_SET_IMAGE = 201
    BGFX_FUNCTION_ID_SET_IMAGE_VIEW = 202
    BGFX_FUNCTION_ID_DISPATCH = 203
    BGFX_FUNCTION_ID_DISPATCH_INDIRECT = 204
    BGFX_FUNCTION_ID_DISCARD = 205
    BGFX_FUNCTION_ID_BLIT = 206
    BGFX_FUNCTION_ID_COUNT = 207
  bgfx_function_id_t* = bgfx_function_id
  PFN_BGFX_GET_INTERFACE* = proc(version: uint32): ptr bgfx_interface_vtbl_t {.cdecl.}

const BGFX_INVALID_HANDLE* = uint16.high

template invalidHandle*(handleType: typedesc): untyped =
  handleType(idx: BGFX_INVALID_HANDLE)

template BGFX_HANDLE_IS_VALID*(handle: untyped): bool =
  handle.idx != BGFX_INVALID_HANDLE


proc attachment_init*(_: type BGFX; this: ptr bgfx_attachment_t; handle: bgfx_texture_handle_t; access: bgfx_access_t; layer: uint16; numLayers: uint16; mip: uint16; resolve: uint8) {.importc: "bgfx_attachment_init", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Init attachment.
  ##
  ## **Parameters:**
  ## - `this` (in): Target object instance.
  ## - `handle` (in): Render target texture handle.
  ## - `access` (in): Access. See `bgfx_access_t`.
  ## - `layer` (in): Cubemap side or depth layer/slice to use.
  ## - `numLayers` (in): Number of texture layer/slice(s) in array to use.
  ## - `mip` (in): Mip level.
  ## - `resolve` (in): Resolve flags. See: `BGFX_RESOLVE_*`
proc vertex_layout_begin*(_: type BGFX; this: ptr bgfx_vertex_layout_t; rendererType: bgfx_renderer_type_t): ptr bgfx_vertex_layout_t {.importc: "bgfx_vertex_layout_begin", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Start VertexLayout.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
  ## - `rendererType` (in): Renderer backend type. See: `bgfx_renderer_type_t`
  ##
  ## **Returns:**
  ## Returns itself.
proc vertex_layout_add*(_: type BGFX; this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t; num: uint8; `type`: bgfx_attrib_type_t; normalized: bool; asInt: bool): ptr bgfx_vertex_layout_t {.importc: "bgfx_vertex_layout_add", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Add attribute to VertexLayout.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
  ## - `attrib` (in): Attribute semantics. See: `bgfx_attrib_t`
  ## - `num` (in): Number of elements 1, 2, 3 or 4.
  ## - `type` (in): Element type.
  ## - `normalized` (in): When using fixed point AttribType (f.e. Uint8)
  ##   value will be normalized for vertex shader usage. When normalized
  ##   is set to true, BGFX_ATTRIB_TYPE_UINT_8 value in range 0-255 will be
  ##   in range 0.0-1.0 in vertex shader.
  ## - `asInt` (in): Packaging rule for vertexPack, vertexUnpack, and
  ##   vertexConvert for BGFX_ATTRIB_TYPE_UINT_8 and BGFX_ATTRIB_TYPE_INT_16.
  ##   Unpacking code must be implemented inside vertex shader.
  ##
  ## **Returns:**
  ## Returns itself.
  ##
  ## **Remarks:**
  ## Must be called between begin/end.
proc vertex_layout_decode*(_: type BGFX; this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t; num: ptr uint8; `type`: ptr bgfx_attrib_type_t; normalized: ptr bool; asInt: ptr bool) {.importc: "bgfx_vertex_layout_decode", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Decode attribute.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
  ## - `attrib` (in): Attribute semantics. See: `bgfx_attrib_t`
  ## - `num` (out): Number of elements.
  ## - `type` (out): Element type.
  ## - `normalized` (out): Attribute is normalized.
  ## - `asInt` (out): Attribute is packed as int.
proc vertex_layout_has*(_: type BGFX; this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t): bool {.importc: "bgfx_vertex_layout_has", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns `true` if VertexLayout contains attribute.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
  ## - `attrib` (in): Attribute semantics. See: `bgfx_attrib_t`
  ##
  ## **Returns:**
  ## True if VertexLayout contains attribute.
proc vertex_layout_skip*(_: type BGFX; this: ptr bgfx_vertex_layout_t; num: uint8): ptr bgfx_vertex_layout_t {.importc: "bgfx_vertex_layout_skip", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Skip `num` bytes in vertex stream.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
  ## - `num` (in): Number of bytes to skip.
  ##
  ## **Returns:**
  ## Returns itself.
proc vertex_layout_end*(_: type BGFX; this: ptr bgfx_vertex_layout_t) {.importc: "bgfx_vertex_layout_end", cdecl, header: "bgfx/c99/bgfx.h".}
  ## End VertexLayout.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
proc vertex_layout_get_offset*(_: type BGFX; this: ptr bgfx_vertex_layout_t; attrib: bgfx_attrib_t): uint16 {.importc: "bgfx_vertex_layout_get_offset", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns relative attribute offset from the vertex.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
  ## - `attrib` (in): Attribute semantics. See: `bgfx_attrib_t`
  ##
  ## **Returns:**
  ## Relative attribute offset from the vertex.
proc vertex_layout_get_stride*(_: type BGFX; this: ptr bgfx_vertex_layout_t): uint16 {.importc: "bgfx_vertex_layout_get_stride", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns vertex stride.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
proc vertex_layout_get_size*(_: type BGFX; this: ptr bgfx_vertex_layout_t; num: uint32): uint32 {.importc: "bgfx_vertex_layout_get_size", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns size of vertex buffer for number of vertices.
  ##
  ## **Parameters:**
  ## - `this` (in): Vertex layout instance.
  ## - `num` (in): Number of vertices.
  ##
  ## **Returns:**
  ## Size of vertex buffer for number of vertices.
proc vertex_pack*(_: type BGFX; input: array[4, cfloat]; inputNormalized: bool; attr: bgfx_attrib_t; layout: ptr bgfx_vertex_layout_t; data: pointer; index: uint32) {.importc: "bgfx_vertex_pack", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Pack vertex attribute into vertex stream format.
  ##
  ## **Parameters:**
  ## - `input` (in): Value to be packed into vertex stream.
  ## - `inputNormalized` (in): `true` if input value is already normalized.
  ## - `attr` (in): Attribute to pack.
  ## - `layout` (in): Vertex stream layout.
  ## - `data` (in): Destination vertex stream where data will be packed.
  ## - `index` (in): Vertex index that will be modified.
proc vertex_unpack*(_: type BGFX; output: var array[4, cfloat]; attr: bgfx_attrib_t; layout: ptr bgfx_vertex_layout_t; data: pointer; index: uint32) {.importc: "bgfx_vertex_unpack", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Unpack vertex attribute from vertex stream format.
  ##
  ## **Parameters:**
  ## - `output` (out): Result of unpacking.
  ## - `attr` (in): Attribute to unpack.
  ## - `layout` (in): Vertex stream layout.
  ## - `data` (in): Source vertex stream from where data will be unpacked.
  ## - `index` (in): Vertex index that will be unpacked.
proc vertex_convert*(_: type BGFX; dstLayout: ptr bgfx_vertex_layout_t; dstData: pointer; srcLayout: ptr bgfx_vertex_layout_t; srcData: pointer; num: uint32) {.importc: "bgfx_vertex_convert", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Converts vertex stream data from one vertex stream format to another.
  ##
  ## **Parameters:**
  ## - `dstLayout` (in): Destination vertex stream layout.
  ## - `dstData` (in): Destination vertex stream.
  ## - `srcLayout` (in): Source vertex stream layout.
  ## - `srcData` (in): Source vertex stream data.
  ## - `num` (in): Number of vertices to convert from source to destination.
proc topology_convert*(_: type BGFX; conversion: bgfx_topology_convert_t; dst: pointer; dstSize: uint32; indices: pointer; numIndices: uint32; index32: bool): uint32 {.importc: "bgfx_topology_convert", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Convert index buffer for use with different primitive topologies.
  ##
  ## **Parameters:**
  ## - `conversion` (in): Conversion type, see `bgfx_topology_convert_t`.
  ## - `dst` (out): Destination index buffer. If this argument is NULL
  ##   function will return number of indices after conversion.
  ## - `dstSize` (in): Destination index buffer in bytes. It must be
  ##   large enough to contain output indices. If destination size is
  ##   insufficient index buffer will be truncated.
  ## - `indices` (in): Source indices.
  ## - `numIndices` (in): Number of input indices.
  ## - `index32` (in): Set to `true` if input indices are 32-bit.
  ##
  ## **Returns:**
  ## Number of output indices after conversion.
proc topology_sort_tri_list*(_: type BGFX; sort: bgfx_topology_sort_t; dst: pointer; dstSize: uint32; dir: array[3, cfloat]; pos: array[3, cfloat]; vertices: pointer; stride: uint32; indices: pointer; numIndices: uint32; index32: bool) {.importc: "bgfx_topology_sort_tri_list", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Sort indices.
  ##
  ## **Parameters:**
  ## - `sort` (in): Sort order, see `bgfx_topology_sort_t`.
  ## - `dst` (out): Destination index buffer.
  ## - `dstSize` (in): Destination index buffer in bytes. It must be
  ##   large enough to contain output indices. If destination size is
  ##   insufficient index buffer will be truncated.
  ## - `dir` (in): Direction (vector must be normalized).
  ## - `pos` (in): Position.
  ## - `vertices` (in): Pointer to first vertex represented as
  ##   float x, y, z. Must contain at least number of vertices
  ##   referencende by index buffer.
  ## - `stride` (in): Vertex stride.
  ## - `indices` (in): Source indices.
  ## - `numIndices` (in): Number of input indices.
  ## - `index32` (in): Set to `true` if input indices are 32-bit.
proc get_supported_renderers*(_: type BGFX; max: uint8; `enum`: ptr bgfx_renderer_type_t): uint8 {.importc: "bgfx_get_supported_renderers", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns supported backend API renderers.
  ##
  ## **Parameters:**
  ## - `max` (in): Maximum number of elements in enum array.
  ## - `enum` (in/out): Array where supported renderers will be written.
  ##
  ## **Returns:**
  ## Number of supported renderers.
proc get_renderer_name*(_: type BGFX; `type`: bgfx_renderer_type_t): cstring {.importc: "bgfx_get_renderer_name", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns name of renderer.
  ##
  ## **Parameters:**
  ## - `type` (in): Renderer backend type. See: `bgfx_renderer_type_t`
  ##
  ## **Returns:**
  ## Name of renderer.
proc init_ctor*(_: type BGFX; init: ptr bgfx_init_t) {.importc: "bgfx_init_ctor", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Fill bgfx_init_t struct with default values, before using it to initialize the library.
  ##
  ## **Parameters:**
  ## - `init` (in): Pointer to structure to be initialized. See: `bgfx_init_t` for more info.
proc init*(_: type BGFX; init: ptr bgfx_init_t): bool {.importc: "bgfx_init", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Initialize the bgfx library.
  ##
  ## **Parameters:**
  ## - `init` (in): Initialization parameters. See: `bgfx_init_t` for more info.
  ##
  ## **Returns:**
  ## `true` if initialization was successful.
proc shutdown*(_: type BGFX) {.importc: "bgfx_shutdown", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Shutdown bgfx library.
proc reset*(_: type BGFX; width: uint32; height: uint32; flags: uint32; format: bgfx_texture_format_t) {.importc: "bgfx_reset", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Reset graphic settings and back-buffer size.
  ##
  ## **Parameters:**
  ## - `width` (in): Back-buffer width.
  ## - `height` (in): Back-buffer height.
  ## - `flags` (in): See: `BGFX_RESET_*` for more info.
  ##   \- `BGFX_RESET_NONE` - No reset flags.
  ##   \- `BGFX_RESET_FULLSCREEN` - Not supported yet.
  ##   \- `BGFX_RESET_MSAA_X[2/4/8/16]` - Enable 2, 4, 8 or 16 x MSAA.
  ##   \- `BGFX_RESET_VSYNC` - Enable V-Sync.
  ##   \- `BGFX_RESET_MAXANISOTROPY` - Turn on/off max anisotropy.
  ##   \- `BGFX_RESET_CAPTURE` - Begin screen capture.
  ##   \- `BGFX_RESET_FLUSH_AFTER_RENDER` - Flush rendering after submitting to GPU.
  ##   \- `BGFX_RESET_FLIP_AFTER_RENDER` - This flag  specifies where flip
  ##   occurs. Default behaviour is that flip occurs before rendering new
  ##   frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.
  ##   \- `BGFX_RESET_SRGB_BACKBUFFER` - Enable sRGB back-buffer.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ##
  ## **Attention:**
  ## This call doesn’t change the window size, it just resizes
  ## the back-buffer. Your windowing code controls the window size.
proc frame*(_: type BGFX; flags: uint8): uint32 {.importc: "bgfx_frame", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Advance to next frame. This is the main frame-advancement call on the
  ## API thread (the thread from which `BGFX.init` was called).
  ##
  ## **Multithreaded renderer** (`BGFX_CONFIG_MULTITHREADED=1`, default):
  ## This call waits for the render thread to finish processing the previous
  ## frame, then swaps internal submit/render buffers, signals the render
  ## thread to begin processing the new frame via `BGFX.render_frame`, and
  ## returns immediately. The render thread and API thread then run in
  ## parallel: the API thread builds the next frame while the render thread
  ## executes GPU commands for the current frame.
  ##
  ## **Single-threaded renderer** (`BGFX_CONFIG_MULTITHREADED=0`, or when
  ## `BGFX.render_frame` and `BGFX.init` are called from the same thread):
  ## This call swaps internal buffers and performs frame rendering inline
  ## (internally calls `BGFX.render_frame`), then returns.
  ##
  ## **Parameters:**
  ## - `flags` (in): Frame flags. See: `BGFX_FRAME_*` for more info.
  ##   \- `BGFX_FRAME_NONE` - No frame flag.
  ##   \- `BGFX_FRAME_DEBUG_CAPTURE` - Capture frame with graphics debugger.
  ##   \- `BGFX_FRAME_DISCARD` - Discard all draw calls.
  ##   \- `BGFX_FRAME_FLUSH` - Execute all rendering commands
  ##   without presenting the backbuffer.
  ##
  ## **Returns:**
  ## Current frame number. This might be used in conjunction with
  ## double/multi buffering data outside the library and passing it to
  ## library via `BGFX.make_ref` calls.
  ##
  ## **Remarks:**
  ## Must be called from the API thread (the thread that called
  ## `BGFX.init`). In multithreaded mode, this call synchronizes with
  ## `BGFX.render_frame` running on the render thread via semaphores:
  ## `BGFX.frame` waits for the render thread to finish, then posts a
  ## signal that `BGFX.render_frame` waits on to begin the next frame.
  ## See also: `BGFX.render_frame`.
proc get_renderer_type*(_: type BGFX): bgfx_renderer_type_t {.importc: "bgfx_get_renderer_type", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns current renderer backend API type.
  ##
  ## **Remarks:**
  ## Library must be initialized.
proc get_caps*(_: type BGFX): ptr bgfx_caps_t {.importc: "bgfx_get_caps", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns renderer capabilities.
  ##
  ## **Remarks:**
  ## Library must be initialized.
proc get_stats*(_: type BGFX): ptr bgfx_stats_t {.importc: "bgfx_get_stats", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns performance counters.
  ##
  ## **Attention:**
  ## Pointer returned is valid until `BGFX.frame` is called.
proc alloc*(_: type BGFX; size: uint32): ptr bgfx_memory_t {.importc: "bgfx_alloc", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Allocate buffer to pass to bgfx calls. Data will be freed inside bgfx.
  ##
  ## **Parameters:**
  ## - `size` (in): Size to allocate.
  ##
  ## **Returns:**
  ## Allocated memory.
proc copy*(_: type BGFX; data: pointer; size: uint32): ptr bgfx_memory_t {.importc: "bgfx_copy", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Allocate buffer and copy data into it. Data will be freed inside bgfx.
  ##
  ## **Parameters:**
  ## - `data` (in): Pointer to data to be copied.
  ## - `size` (in): Size of data to be copied.
  ##
  ## **Returns:**
  ## Allocated memory.
proc make_ref*(_: type BGFX; data: pointer; size: uint32): ptr bgfx_memory_t {.importc: "bgfx_make_ref", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Make reference to data to pass to bgfx. Unlike `BGFX.alloc`, this call
  ## doesn't allocate memory for data. It just copies the data pointer. You
  ## can pass `bgfx_release_fn_t` function pointer to release this memory after it's
  ## consumed, otherwise you must make sure data is available for at least 2
  ## `BGFX.frame` calls. `bgfx_release_fn_t` function must be able to be called
  ## from any thread.
  ##
  ## **Parameters:**
  ## - `data` (in): Pointer to data.
  ## - `size` (in): Size of data.
  ##
  ## **Returns:**
  ## Referenced memory.
  ##
  ## **Attention:**
  ## Data passed must be available for at least 2 `BGFX.frame` calls.
proc make_ref_release*(_: type BGFX; data: pointer; size: uint32; releaseFn: bgfx_release_fn_t; userData: pointer): ptr bgfx_memory_t {.importc: "bgfx_make_ref_release", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Make reference to data to pass to bgfx. Unlike `BGFX.alloc`, this call
  ## doesn't allocate memory for data. It just copies the data pointer. You
  ## can pass `bgfx_release_fn_t` function pointer to release this memory after it's
  ## consumed, otherwise you must make sure data is available for at least 2
  ## `BGFX.frame` calls. `bgfx_release_fn_t` function must be able to be called
  ## from any thread.
  ##
  ## **Parameters:**
  ## - `data` (in): Pointer to data.
  ## - `size` (in): Size of data.
  ## - `releaseFn` (in): Callback function to release memory after use.
  ## - `userData` (in): User data to be passed to callback function.
  ##
  ## **Returns:**
  ## Referenced memory.
  ##
  ## **Attention:**
  ## Data passed must be available for at least 2 `BGFX.frame` calls.
proc set_debug*(_: type BGFX; debug: uint32) {.importc: "bgfx_set_debug", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set debug flags.
  ##
  ## **Parameters:**
  ## - `debug` (in): Available flags:
  ##   \- `BGFX_DEBUG_IFH` - Infinitely fast hardware. When this flag is set
  ##   all rendering calls will be skipped. This is useful when profiling
  ##   to quickly assess potential bottlenecks between CPU and GPU.
  ##   \- `BGFX_DEBUG_PROFILER` - Enable profiler.
  ##   \- `BGFX_DEBUG_STATS` - Display internal statistics.
  ##   \- `BGFX_DEBUG_TEXT` - Display debug text.
  ##   \- `BGFX_DEBUG_WIREFRAME` - Wireframe rendering. All rendering
  ##   primitives will be rendered as lines.
proc dbg_text_clear*(_: type BGFX; attr: uint8; small: bool) {.importc: "bgfx_dbg_text_clear", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Clear internal debug text buffer.
  ##
  ## **Parameters:**
  ## - `attr` (in): Background color.
  ## - `small` (in): Default 8x16 or 8x8 font.
proc dbg_text_printf*(_: type BGFX; x: uint16; y: uint16; attr: uint8; format: cstring) {.importc: "bgfx_dbg_text_printf", cdecl, varargs, header: "bgfx/c99/bgfx.h".}
  ## Print formatted data to internal debug text character-buffer (VGA-compatible text mode).
  ##
  ## **Parameters:**
  ## - `x` (in): Position x from the left corner of the window.
  ## - `y` (in): Position y from the top corner of the window.
  ## - `attr` (in): Color palette. Where top 4-bits represent index of background, and bottom
  ##   4-bits represent foreground color from standard VGA text palette (ANSI escape codes).
  ## - `format` (in): `printf` style format.
proc dbg_text_vprintf*(_: type BGFX; x: uint16; y: uint16; attr: uint8; format: cstring; argList: bgfx_va_list_t) {.importc: "bgfx_dbg_text_vprintf", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Print formatted data from variable argument list to internal debug text character-buffer (VGA-compatible text mode).
  ##
  ## **Parameters:**
  ## - `x` (in): Position x from the left corner of the window.
  ## - `y` (in): Position y from the top corner of the window.
  ## - `attr` (in): Color palette. Where top 4-bits represent index of background, and bottom
  ##   4-bits represent foreground color from standard VGA text palette (ANSI escape codes).
  ## - `format` (in): `printf` style format.
  ## - `argList` (in): Variable arguments list for format string.
proc dbg_text_image*(_: type BGFX; x: uint16; y: uint16; width: uint16; height: uint16; data: pointer; pitch: uint16) {.importc: "bgfx_dbg_text_image", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Draw image into internal debug text buffer.
  ##
  ## **Parameters:**
  ## - `x` (in): Position x from the left corner of the window.
  ## - `y` (in): Position y from the top corner of the window.
  ## - `width` (in): Image width.
  ## - `height` (in): Image height.
  ## - `data` (in): Raw image data (character/attribute raw encoding).
  ## - `pitch` (in): Image pitch in bytes.
proc create_index_buffer*(_: type BGFX; mem: ptr bgfx_memory_t; flags: uint16): bgfx_index_buffer_handle_t {.importc: "bgfx_create_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create static index buffer.
  ##
  ## **Parameters:**
  ## - `mem` (in): Index buffer data.
  ## - `flags` (in): Buffer creation flags.
  ##   \- `BGFX_BUFFER_NONE` - No flags.
  ##   \- `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
  ##   \- `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
  ##   is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
  ##   \- `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
  ##   \- `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
  ##   data is passed. If this flag is not specified, and more data is passed on update, the buffer
  ##   will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
  ##   buffers.
  ##   \- `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
  ##   index buffers.
proc set_index_buffer_name*(_: type BGFX; handle: bgfx_index_buffer_handle_t; name: cstring; len: int32) {.importc: "bgfx_set_index_buffer_name", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set static index buffer debug name.
  ##
  ## **Parameters:**
  ## - `handle` (in): Static index buffer handle.
  ## - `name` (in): Static index buffer name.
  ## - `len` (in): Static index buffer name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string.
proc destroy_index_buffer*(_: type BGFX; handle: bgfx_index_buffer_handle_t) {.importc: "bgfx_destroy_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy static index buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Static index buffer handle.
proc create_vertex_layout*(_: type BGFX; layout: ptr bgfx_vertex_layout_t): bgfx_vertex_layout_handle_t {.importc: "bgfx_create_vertex_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create vertex layout. Vertex layouts are used to describe the format of vertex data.
  ##
  ## **Parameters:**
  ## - `layout` (in): Vertex layout.
proc destroy_vertex_layout*(_: type BGFX; layoutHandle: bgfx_vertex_layout_handle_t) {.importc: "bgfx_destroy_vertex_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy vertex layout.
  ##
  ## **Parameters:**
  ## - `layoutHandle` (in): Vertex layout handle.
proc create_vertex_buffer*(_: type BGFX; mem: ptr bgfx_memory_t; layout: ptr bgfx_vertex_layout_t; flags: uint16): bgfx_vertex_buffer_handle_t {.importc: "bgfx_create_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create static vertex buffer.
  ##
  ## **Parameters:**
  ## - `mem` (in): Vertex buffer data.
  ## - `layout` (in): Vertex layout.
  ## - `flags` (in): Buffer creation flags.
  ##   \- `BGFX_BUFFER_NONE` - No flags.
  ##   \- `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
  ##   \- `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
  ##   is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
  ##   \- `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
  ##   \- `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
  ##   data is passed. If this flag is not specified, and more data is passed on update, the buffer
  ##   will be trimmed to fit the existing buffer size. This flag has effect only on dynamic buffers.
  ##   \- `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on index buffers.
  ##
  ## **Returns:**
  ## Static vertex buffer handle.
proc set_vertex_buffer_name*(_: type BGFX; handle: bgfx_vertex_buffer_handle_t; name: cstring; len: int32) {.importc: "bgfx_set_vertex_buffer_name", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set static vertex buffer debug name.
  ##
  ## **Parameters:**
  ## - `handle` (in): Static vertex buffer handle.
  ## - `name` (in): Static vertex buffer name.
  ## - `len` (in): Static vertex buffer name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string.
proc destroy_vertex_buffer*(_: type BGFX; handle: bgfx_vertex_buffer_handle_t) {.importc: "bgfx_destroy_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy static vertex buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Static vertex buffer handle.
proc create_dynamic_index_buffer*(_: type BGFX; num: uint32; flags: uint16): bgfx_dynamic_index_buffer_handle_t {.importc: "bgfx_create_dynamic_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create empty dynamic index buffer.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of indices.
  ## - `flags` (in): Buffer creation flags.
  ##   \- `BGFX_BUFFER_NONE` - No flags.
  ##   \- `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
  ##   \- `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
  ##   is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
  ##   \- `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
  ##   \- `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
  ##   data is passed. If this flag is not specified, and more data is passed on update, the buffer
  ##   will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
  ##   buffers.
  ##   \- `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
  ##   index buffers.
  ##
  ## **Returns:**
  ## Dynamic index buffer handle.
proc create_dynamic_index_buffer_mem*(_: type BGFX; mem: ptr bgfx_memory_t; flags: uint16): bgfx_dynamic_index_buffer_handle_t {.importc: "bgfx_create_dynamic_index_buffer_mem", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create a dynamic index buffer and initialize it.
  ##
  ## **Parameters:**
  ## - `mem` (in): Index buffer data.
  ## - `flags` (in): Buffer creation flags.
  ##   \- `BGFX_BUFFER_NONE` - No flags.
  ##   \- `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
  ##   \- `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
  ##   is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
  ##   \- `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
  ##   \- `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
  ##   data is passed. If this flag is not specified, and more data is passed on update, the buffer
  ##   will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
  ##   buffers.
  ##   \- `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
  ##   index buffers.
  ##
  ## **Returns:**
  ## Dynamic index buffer handle.
proc update_dynamic_index_buffer*(_: type BGFX; handle: bgfx_dynamic_index_buffer_handle_t; startIndex: uint32; mem: ptr bgfx_memory_t) {.importc: "bgfx_update_dynamic_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Update dynamic index buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Dynamic index buffer handle.
  ## - `startIndex` (in): Start index.
  ## - `mem` (in): Index buffer data.
proc destroy_dynamic_index_buffer*(_: type BGFX; handle: bgfx_dynamic_index_buffer_handle_t) {.importc: "bgfx_destroy_dynamic_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy dynamic index buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Dynamic index buffer handle.
proc create_dynamic_vertex_buffer*(_: type BGFX; num: uint32; layout: ptr bgfx_vertex_layout_t; flags: uint16): bgfx_dynamic_vertex_buffer_handle_t {.importc: "bgfx_create_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create empty dynamic vertex buffer.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of vertices.
  ## - `layout` (in): Vertex layout.
  ## - `flags` (in): Buffer creation flags.
  ##   \- `BGFX_BUFFER_NONE` - No flags.
  ##   \- `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
  ##   \- `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
  ##   is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
  ##   \- `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
  ##   \- `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
  ##   data is passed. If this flag is not specified, and more data is passed on update, the buffer
  ##   will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
  ##   buffers.
  ##   \- `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
  ##   index buffers.
  ##
  ## **Returns:**
  ## Dynamic vertex buffer handle.
proc create_dynamic_vertex_buffer_mem*(_: type BGFX; mem: ptr bgfx_memory_t; layout: ptr bgfx_vertex_layout_t; flags: uint16): bgfx_dynamic_vertex_buffer_handle_t {.importc: "bgfx_create_dynamic_vertex_buffer_mem", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create dynamic vertex buffer and initialize it.
  ##
  ## **Parameters:**
  ## - `mem` (in): Vertex buffer data.
  ## - `layout` (in): Vertex layout.
  ## - `flags` (in): Buffer creation flags.
  ##   \- `BGFX_BUFFER_NONE` - No flags.
  ##   \- `BGFX_BUFFER_COMPUTE_READ` - Buffer will be read from by compute shader.
  ##   \- `BGFX_BUFFER_COMPUTE_WRITE` - Buffer will be written into by compute shader. When buffer
  ##   is created with `BGFX_BUFFER_COMPUTE_WRITE` flag it cannot be updated from CPU.
  ##   \- `BGFX_BUFFER_COMPUTE_READ_WRITE` - Buffer will be used for read/write by compute shader.
  ##   \- `BGFX_BUFFER_ALLOW_RESIZE` - Buffer will resize on buffer update if a different amount of
  ##   data is passed. If this flag is not specified, and more data is passed on update, the buffer
  ##   will be trimmed to fit the existing buffer size. This flag has effect only on dynamic
  ##   buffers.
  ##   \- `BGFX_BUFFER_INDEX32` - Buffer is using 32-bit indices. This flag has effect only on
  ##   index buffers.
  ##
  ## **Returns:**
  ## Dynamic vertex buffer handle.
proc update_dynamic_vertex_buffer*(_: type BGFX; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; mem: ptr bgfx_memory_t) {.importc: "bgfx_update_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Update dynamic vertex buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Dynamic vertex buffer handle.
  ## - `startVertex` (in): Start vertex.
  ## - `mem` (in): Vertex buffer data.
proc destroy_dynamic_vertex_buffer*(_: type BGFX; handle: bgfx_dynamic_vertex_buffer_handle_t) {.importc: "bgfx_destroy_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy dynamic vertex buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Dynamic vertex buffer handle.
proc get_avail_transient_index_buffer*(_: type BGFX; num: uint32; index32: bool): uint32 {.importc: "bgfx_get_avail_transient_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns number of requested or maximum available indices.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of required indices.
  ## - `index32` (in): Set to `true` if input indices will be 32-bit.
  ##
  ## **Returns:**
  ## Number of requested or maximum available indices.
proc get_avail_transient_vertex_buffer*(_: type BGFX; num: uint32; layout: ptr bgfx_vertex_layout_t): uint32 {.importc: "bgfx_get_avail_transient_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns number of requested or maximum available vertices.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of required vertices.
  ## - `layout` (in): Vertex layout.
  ##
  ## **Returns:**
  ## Number of requested or maximum available vertices.
proc get_avail_instance_data_buffer*(_: type BGFX; num: uint32; stride: uint16): uint32 {.importc: "bgfx_get_avail_instance_data_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns number of requested or maximum available instance buffer slots.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of required instances.
  ## - `stride` (in): Stride per instance.
  ##
  ## **Returns:**
  ## Number of requested or maximum available instance buffer slots.
proc alloc_transient_index_buffer*(_: type BGFX; tib: ptr bgfx_transient_index_buffer_t; num: uint32; index32: bool) {.importc: "bgfx_alloc_transient_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Allocate transient index buffer.
  ##
  ## **Parameters:**
  ## - `tib` (out): TransientIndexBuffer structure will be filled, and will be valid
  ##   for the duration of frame, and can be reused for multiple draw
  ##   calls.
  ## - `num` (in): Number of indices to allocate.
  ## - `index32` (in): Set to `true` if input indices will be 32-bit.
proc alloc_transient_vertex_buffer*(_: type BGFX; tvb: ptr bgfx_transient_vertex_buffer_t; num: uint32; layout: ptr bgfx_vertex_layout_t) {.importc: "bgfx_alloc_transient_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Allocate transient vertex buffer.
  ##
  ## **Parameters:**
  ## - `tvb` (out): TransientVertexBuffer structure will be filled, and will be valid
  ##   for the duration of frame, and can be reused for multiple draw
  ##   calls.
  ## - `num` (in): Number of vertices to allocate.
  ## - `layout` (in): Vertex layout.
proc alloc_transient_buffers*(_: type BGFX; tvb: ptr bgfx_transient_vertex_buffer_t; layout: ptr bgfx_vertex_layout_t; numVertices: uint32; tib: ptr bgfx_transient_index_buffer_t; numIndices: uint32; index32: bool): bool {.importc: "bgfx_alloc_transient_buffers", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Check for required space and allocate transient vertex and index
  ## buffers. If both space requirements are satisfied function returns
  ## true.
  ##
  ## **Parameters:**
  ## - `tvb` (out): TransientVertexBuffer structure will be filled, and will be valid
  ##   for the duration of frame, and can be reused for multiple draw
  ##   calls.
  ## - `layout` (in): Vertex layout.
  ## - `numVertices` (in): Number of vertices to allocate.
  ## - `tib` (out): TransientIndexBuffer structure will be filled, and will be valid
  ##   for the duration of frame, and can be reused for multiple draw
  ##   calls.
  ## - `numIndices` (in): Number of indices to allocate.
  ## - `index32` (in): Set to `true` if input indices will be 32-bit.
proc alloc_instance_data_buffer*(_: type BGFX; idb: ptr bgfx_instance_data_buffer_t; num: uint32; stride: uint16) {.importc: "bgfx_alloc_instance_data_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Allocate instance data buffer.
  ##
  ## **Parameters:**
  ## - `idb` (out): InstanceDataBuffer structure will be filled, and will be valid
  ##   for duration of frame, and can be reused for multiple draw
  ##   calls.
  ## - `num` (in): Number of instances.
  ## - `stride` (in): Instance stride. Must be multiple of 16.
proc create_indirect_buffer*(_: type BGFX; num: uint32): bgfx_indirect_buffer_handle_t {.importc: "bgfx_create_indirect_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create draw indirect buffer.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of indirect calls.
  ##
  ## **Returns:**
  ## Indirect buffer handle.
proc destroy_indirect_buffer*(_: type BGFX; handle: bgfx_indirect_buffer_handle_t) {.importc: "bgfx_destroy_indirect_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy draw indirect buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Indirect buffer handle.
proc create_shader*(_: type BGFX; mem: ptr bgfx_memory_t): bgfx_shader_handle_t {.importc: "bgfx_create_shader", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create shader from memory buffer.
  ##
  ## **Parameters:**
  ## - `mem` (in): Shader binary.
  ##
  ## **Returns:**
  ## Shader handle.
  ##
  ## **Remarks:**
  ## Shader binary is obtained by compiling shader offline with shaderc command line tool.
proc get_shader_uniforms*(_: type BGFX; handle: bgfx_shader_handle_t; uniforms: ptr bgfx_uniform_handle_t; max: uint16): uint16 {.importc: "bgfx_get_shader_uniforms", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns the number of uniforms and uniform handles used inside a shader.
  ##
  ## **Parameters:**
  ## - `handle` (in): Shader handle.
  ## - `uniforms` (out): UniformHandle array where data will be stored.
  ## - `max` (in): Maximum capacity of array.
  ##
  ## **Returns:**
  ## Number of uniforms used by shader.
  ##
  ## **Remarks:**
  ## Only non-predefined uniforms are returned.
proc set_shader_name*(_: type BGFX; handle: bgfx_shader_handle_t; name: cstring; len: int32) {.importc: "bgfx_set_shader_name", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set shader debug name.
  ##
  ## **Parameters:**
  ## - `handle` (in): Shader handle.
  ## - `name` (in): Shader name.
  ## - `len` (in): Shader name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string).
proc destroy_shader*(_: type BGFX; handle: bgfx_shader_handle_t) {.importc: "bgfx_destroy_shader", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy shader.
  ##
  ## **Parameters:**
  ## - `handle` (in): Shader handle.
  ##
  ## **Remarks:**
  ## Once a shader program is created with handle,
  ## it is safe to destroy that shader.
proc create_program*(_: type BGFX; vsh: bgfx_shader_handle_t; fsh: bgfx_shader_handle_t; destroyShaders: bool): bgfx_program_handle_t {.importc: "bgfx_create_program", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create program with vertex and fragment shaders.
  ##
  ## **Parameters:**
  ## - `vsh` (in): Vertex shader.
  ## - `fsh` (in): Fragment shader.
  ## - `destroyShaders` (in): If true, shaders will be destroyed when program is destroyed.
  ##
  ## **Returns:**
  ## Program handle if vertex shader output and fragment shader
  ## input are matching, otherwise returns invalid program handle.
proc create_compute_program*(_: type BGFX; csh: bgfx_shader_handle_t; destroyShaders: bool): bgfx_program_handle_t {.importc: "bgfx_create_compute_program", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create program with compute shader.
  ##
  ## **Parameters:**
  ## - `csh` (in): Compute shader.
  ## - `destroyShaders` (in): If true, shaders will be destroyed when program is destroyed.
  ##
  ## **Returns:**
  ## Program handle.
proc destroy_program*(_: type BGFX; handle: bgfx_program_handle_t) {.importc: "bgfx_destroy_program", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy program.
  ##
  ## **Parameters:**
  ## - `handle` (in): Program handle.
proc is_texture_valid*(_: type BGFX; depth: uint16; cubeMap: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64): bool {.importc: "bgfx_is_texture_valid", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Validate texture parameters.
  ##
  ## **Parameters:**
  ## - `depth` (in): Depth dimension of volume texture.
  ## - `cubeMap` (in): Indicates that texture contains cubemap.
  ## - `numLayers` (in): Number of layers in texture array.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `flags` (in): Texture flags. See `BGFX_TEXTURE_*`.
  ##
  ## **Returns:**
  ## True if a texture with the same parameters can be created.
proc is_video_codec_valid*(_: type BGFX; codec: bgfx_video_codec_t; chroma: uint8; bitDepth: uint8; codedWidth: uint16; codedHeight: uint16; maxDpbSlots: uint8; maxActiveReferences: uint8): bool {.importc: "bgfx_is_video_codec_valid", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Validate video codec parameters. Use to check whether the requested
  ## combination of codec / bit depth / chroma / dimensions / DPB layout can
  ## be hardware decoded on the current device. Coarse capability discovery
  ## is `bgfx_caps_t.supported & BGFX_CAPS_VIDEO_DECODE` and `bgfx_caps_t.codecs[]`.
  ##
  ## **Parameters:**
  ## - `codec` (in): Video codec. See: `bgfx_video_codec_t`.
  ## - `chroma` (in): Chroma subsampling. 0 = 4:2:0, 2 = 4:2:2, 4 = 4:4:4.
  ## - `bitDepth` (in): Bit depth per component. 8, 10 or 12.
  ## - `codedWidth` (in): Coded picture width (macroblock / CTU / superblock aligned).
  ## - `codedHeight` (in): Coded picture height.
  ## - `maxDpbSlots` (in): Maximum decoded picture buffer slot count.
  ## - `maxActiveReferences` (in): Maximum number of reference frames active at once.
  ##
  ## **Returns:**
  ## True if a video decoder with the same parameters can be created.
proc is_frame_buffer_valid*(_: type BGFX; num: uint8; attachment: ptr bgfx_attachment_t): bool {.importc: "bgfx_is_frame_buffer_valid", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Validate frame buffer parameters.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of attachments.
  ## - `attachment` (in): Attachment texture info. See: `bgfx_attachment_t`.
  ##
  ## **Returns:**
  ## True if a frame buffer with the same parameters can be created.
proc calc_texture_size*(_: type BGFX; info: ptr bgfx_texture_info_t; width: uint16; height: uint16; depth: uint16; cubeMap: bool; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t) {.importc: "bgfx_calc_texture_size", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Calculate amount of memory required for texture.
  ##
  ## **Parameters:**
  ## - `info` (out): Resulting texture info structure. See: `bgfx_texture_info_t`.
  ## - `width` (in): Width.
  ## - `height` (in): Height.
  ## - `depth` (in): Depth dimension of volume texture.
  ## - `cubeMap` (in): Indicates that texture contains cubemap.
  ## - `hasMips` (in): Indicates that texture contains full mip-map chain.
  ## - `numLayers` (in): Number of layers in texture array.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
proc create_texture*(_: type BGFX; mem: ptr bgfx_memory_t; flags: uint64; skip: uint8; info: ptr bgfx_texture_info_t): bgfx_texture_handle_t {.importc: "bgfx_create_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create texture from memory buffer.
  ##
  ## **Parameters:**
  ## - `mem` (in): DDS, KTX or PVR texture binary data.
  ## - `flags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ## - `skip` (in): Skip top level mips when parsing texture.
  ## - `info` (out): When non-`NULL` is specified it returns parsed texture information.
  ##
  ## **Returns:**
  ## Texture handle.
proc create_texture_2d*(_: type BGFX; width: uint16; height: uint16; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64; mem: ptr bgfx_memory_t; external: uint64): bgfx_texture_handle_t {.importc: "bgfx_create_texture_2d", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create 2D texture.
  ##
  ## **Parameters:**
  ## - `width` (in): Width.
  ## - `height` (in): Height.
  ## - `hasMips` (in): Indicates that texture contains full mip-map chain.
  ## - `numLayers` (in): Number of layers in texture array. Must be 1 if caps
  ##   `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `flags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ## - `mem` (in): Texture data. If `mem` is non-NULL, created texture will be immutable. If
  ##   `mem` is NULL content of the texture is uninitialized. When `numLayers` is more than
  ##   1, expected memory layout is texture and all mips together for each array element.
  ## - `external` (in): Native API pointer to texture.
  ##
  ## **Returns:**
  ## Texture handle.
proc create_texture_2d_scaled*(_: type BGFX; ratio: bgfx_backbuffer_ratio_t; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64): bgfx_texture_handle_t {.importc: "bgfx_create_texture_2d_scaled", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create texture with size based on back-buffer ratio. Texture will maintain ratio
  ## if back buffer resolution changes.
  ##
  ## **Parameters:**
  ## - `ratio` (in): Texture size in respect to back-buffer size. See: `bgfx_backbuffer_ratio_t`.
  ## - `hasMips` (in): Indicates that texture contains full mip-map chain.
  ## - `numLayers` (in): Number of layers in texture array. Must be 1 if caps
  ##   `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `flags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ##
  ## **Returns:**
  ## Texture handle.
proc create_texture_3d*(_: type BGFX; width: uint16; height: uint16; depth: uint16; hasMips: bool; format: bgfx_texture_format_t; flags: uint64; mem: ptr bgfx_memory_t; external: uint64): bgfx_texture_handle_t {.importc: "bgfx_create_texture_3d", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create 3D texture.
  ##
  ## **Parameters:**
  ## - `width` (in): Width.
  ## - `height` (in): Height.
  ## - `depth` (in): Depth.
  ## - `hasMips` (in): Indicates that texture contains full mip-map chain.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `flags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ## - `mem` (in): Texture data. If `mem` is non-NULL, created texture will be immutable. If
  ##   `mem` is NULL content of the texture is uninitialized. When `numLayers` is more than
  ##   1, expected memory layout is texture and all mips together for each array element.
  ## - `external` (in): Native API pointer to texture.
  ##
  ## **Returns:**
  ## Texture handle.
proc create_texture_cube*(_: type BGFX; size: uint16; hasMips: bool; numLayers: uint16; format: bgfx_texture_format_t; flags: uint64; mem: ptr bgfx_memory_t; external: uint64): bgfx_texture_handle_t {.importc: "bgfx_create_texture_cube", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create Cube texture.
  ##
  ## **Parameters:**
  ## - `size` (in): Cube side size.
  ## - `hasMips` (in): Indicates that texture contains full mip-map chain.
  ## - `numLayers` (in): Number of layers in texture array. Must be 1 if caps
  ##   `BGFX_CAPS_TEXTURE_2D_ARRAY` flag is not set.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `flags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ## - `mem` (in): Texture data. If `mem` is non-NULL, created texture will be immutable. If
  ##   `mem` is NULL content of the texture is uninitialized. When `numLayers` is more than
  ## - `external` (in): Native API pointer to texture.
  ##
  ## **Returns:**
  ## Texture handle.
proc update_texture_2d*(_: type BGFX; handle: bgfx_texture_handle_t; layer: uint16; mip: uint8; x: uint16; y: uint16; width: uint16; height: uint16; mem: ptr bgfx_memory_t; pitch: uint16) {.importc: "bgfx_update_texture_2d", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Update 2D texture.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `layer` (in): Layer in texture array.
  ## - `mip` (in): Mip level.
  ## - `x` (in): X offset in texture.
  ## - `y` (in): Y offset in texture.
  ## - `width` (in): Width of texture block.
  ## - `height` (in): Height of texture block.
  ## - `mem` (in): Texture update data.
  ## - `pitch` (in): Pitch of input image (bytes). When pitch is set to
  ##   UINT16_MAX, it will be calculated internally based on width.
  ##
  ## **Attention:**
  ## It's valid to update only mutable texture. See `BGFX.create_texture_2d` for more info.
proc update_texture_3d*(_: type BGFX; handle: bgfx_texture_handle_t; mip: uint8; x: uint16; y: uint16; z: uint16; width: uint16; height: uint16; depth: uint16; mem: ptr bgfx_memory_t) {.importc: "bgfx_update_texture_3d", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Update 3D texture.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `mip` (in): Mip level.
  ## - `x` (in): X offset in texture.
  ## - `y` (in): Y offset in texture.
  ## - `z` (in): Z offset in texture.
  ## - `width` (in): Width of texture block.
  ## - `height` (in): Height of texture block.
  ## - `depth` (in): Depth of texture block.
  ## - `mem` (in): Texture update data.
  ##
  ## **Attention:**
  ## It's valid to update only mutable texture. See `BGFX.create_texture_3d` for more info.
proc update_texture_cube*(_: type BGFX; handle: bgfx_texture_handle_t; layer: uint16; side: uint8; mip: uint8; x: uint16; y: uint16; width: uint16; height: uint16; mem: ptr bgfx_memory_t; pitch: uint16) {.importc: "bgfx_update_texture_cube", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Update Cube texture.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `layer` (in): Layer in texture array.
  ## - `side` (in): Cubemap side `BGFX_CUBE_MAP_<POSITIVE or NEGATIVE>_<X, Y or Z>`,
  ##   where 0 is +X, 1 is -X, 2 is +Y, 3 is -Y, 4 is +Z, and 5 is -Z.
  ##   \+----------+
  ##   \|-z       2|
  ##   \| ^  +y    |
  ##   \| |        |    Unfolded cube:
  ##   \| +---->+x |
  ##   \+----------+----------+----------+----------+
  ##   \|+y       1|+y       4|+y       0|+y       5|
  ##   \| ^  -x    | ^  +z    | ^  +x    | ^  -z    |
  ##   \| |        | |        | |        | |        |
  ##   \| +---->+z | +---->+x | +---->-z | +---->-x |
  ##   \+----------+----------+----------+----------+
  ##   \|+z       3|
  ##   \| ^  -y    |
  ##   \| |        |
  ##   \| +---->+x |
  ##   \+----------+
  ## - `mip` (in): Mip level.
  ## - `x` (in): X offset in texture.
  ## - `y` (in): Y offset in texture.
  ## - `width` (in): Width of texture block.
  ## - `height` (in): Height of texture block.
  ## - `mem` (in): Texture update data.
  ## - `pitch` (in): Pitch of input image (bytes). When pitch is set to
  ##   UINT16_MAX, it will be calculated internally based on width.
  ##
  ## **Attention:**
  ## It's valid to update only mutable texture. See `BGFX.create_texture_cube` for more info.
proc clear_texture*(_: type BGFX; handle: bgfx_texture_handle_t; mip: uint8; numMips: uint8; layer: uint16; numLayers: uint16) {.importc: "bgfx_clear_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Clear a texture subresource range to zero.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `mip` (in): First mip level.
  ## - `numMips` (in): Number of mip levels.
  ## - `layer` (in): First array layer (or 3D depth slice base).
  ## - `numLayers` (in): Number of layers.
proc read_texture*(_: type BGFX; handle: bgfx_texture_handle_t; data: pointer; layer: uint16; mip: uint8): uint32 {.importc: "bgfx_read_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Read back texture content.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `data` (in): Destination buffer.
  ## - `layer` (in): Texture layer.
  ## - `mip` (in): Mip level.
  ##
  ## **Returns:**
  ## Frame number when the result will be available. See: `BGFX.frame`.
  ##
  ## **Attention:**
  ## Texture must be created with `BGFX_TEXTURE_READ_BACK` flag.
  ## It's a texture for CPU readback, and can't be a GPU resource
  ## at the same time. See `examples/30-picking`.
  ##
  ## Availability depends on: `BGFX_CAPS_TEXTURE_READ_BACK`.
proc set_texture_name*(_: type BGFX; handle: bgfx_texture_handle_t; name: cstring; len: int32) {.importc: "bgfx_set_texture_name", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set texture debug name.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `name` (in): Texture name.
  ## - `len` (in): Texture name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string.
proc get_direct_access_ptr*(_: type BGFX; handle: bgfx_texture_handle_t): pointer {.importc: "bgfx_get_direct_access_ptr", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Returns texture direct access pointer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ##
  ## **Returns:**
  ## Pointer to texture memory. If returned pointer is `NULL` direct access
  ## is not available for this texture. If pointer is `UINTPTR_MAX` sentinel value
  ## it means texture is pending creation. Pointer returned can be cached and it
  ## will be valid until texture is destroyed.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_TEXTURE_DIRECT_ACCESS`. This feature
  ## is available on GPUs that have unified memory architecture (UMA) support.
proc destroy_texture*(_: type BGFX; handle: bgfx_texture_handle_t) {.importc: "bgfx_destroy_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy texture.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
proc create_frame_buffer*(_: type BGFX; width: uint16; height: uint16; format: bgfx_texture_format_t; textureFlags: uint64): bgfx_frame_buffer_handle_t {.importc: "bgfx_create_frame_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create frame buffer (simple).
  ##
  ## **Parameters:**
  ## - `width` (in): Texture width.
  ## - `height` (in): Texture height.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `textureFlags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ##
  ## **Returns:**
  ## Frame buffer handle.
proc create_frame_buffer_scaled*(_: type BGFX; ratio: bgfx_backbuffer_ratio_t; format: bgfx_texture_format_t; textureFlags: uint64): bgfx_frame_buffer_handle_t {.importc: "bgfx_create_frame_buffer_scaled", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create frame buffer with size based on back-buffer ratio. Frame buffer will maintain ratio
  ## if back buffer resolution changes.
  ##
  ## **Parameters:**
  ## - `ratio` (in): Frame buffer size in respect to back-buffer size. See:
  ##   `bgfx_backbuffer_ratio_t`.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `textureFlags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ##
  ## **Returns:**
  ## Frame buffer handle.
proc create_frame_buffer_from_handles*(_: type BGFX; num: uint8; handles: ptr bgfx_texture_handle_t; destroyTexture: bool): bgfx_frame_buffer_handle_t {.importc: "bgfx_create_frame_buffer_from_handles", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create MRT frame buffer from texture handles (simple).
  ##
  ## **Parameters:**
  ## - `num` (in): Number of texture handles.
  ## - `handles` (in): Texture attachments.
  ## - `destroyTexture` (in): If true, textures will be destroyed when
  ##   frame buffer is destroyed.
  ##
  ## **Returns:**
  ## Frame buffer handle.
proc create_frame_buffer_from_attachment*(_: type BGFX; num: uint8; attachment: ptr bgfx_attachment_t; destroyTexture: bool): bgfx_frame_buffer_handle_t {.importc: "bgfx_create_frame_buffer_from_attachment", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create MRT frame buffer from texture handles with specific layer and
  ## mip level.
  ##
  ## **Parameters:**
  ## - `num` (in): Number of attachments.
  ## - `attachment` (in): Attachment texture info. See: `bgfx_attachment_t`.
  ## - `destroyTexture` (in): If true, textures will be destroyed when
  ##   frame buffer is destroyed.
  ##
  ## **Returns:**
  ## Frame buffer handle.
proc create_frame_buffer_from_nwh*(_: type BGFX; nwh: pointer; width: uint16; height: uint16; format: bgfx_texture_format_t; depthFormat: bgfx_texture_format_t): bgfx_frame_buffer_handle_t {.importc: "bgfx_create_frame_buffer_from_nwh", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create frame buffer for multiple window rendering.
  ##
  ## **Parameters:**
  ## - `nwh` (in): OS' target native window handle.
  ## - `width` (in): Window back buffer width.
  ## - `height` (in): Window back buffer height.
  ## - `format` (in): Window back buffer color format.
  ## - `depthFormat` (in): Window back buffer depth format.
  ##
  ## **Returns:**
  ## Frame buffer handle.
  ##
  ## **Remarks:**
  ## Frame buffer cannot be used for sampling.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_SWAP_CHAIN`.
proc set_frame_buffer_name*(_: type BGFX; handle: bgfx_frame_buffer_handle_t; name: cstring; len: int32) {.importc: "bgfx_set_frame_buffer_name", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set frame buffer debug name.
  ##
  ## **Parameters:**
  ## - `handle` (in): Frame buffer handle.
  ## - `name` (in): Frame buffer name.
  ## - `len` (in): Frame buffer name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string.
proc get_texture*(_: type BGFX; handle: bgfx_frame_buffer_handle_t; attachment: uint8): bgfx_texture_handle_t {.importc: "bgfx_get_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Obtain texture handle of frame buffer attachment.
  ##
  ## **Parameters:**
  ## - `handle` (in): Frame buffer handle.
  ## - `attachment` (in):
proc destroy_frame_buffer*(_: type BGFX; handle: bgfx_frame_buffer_handle_t) {.importc: "bgfx_destroy_frame_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy frame buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Frame buffer handle.
proc create_uniform*(_: type BGFX; name: cstring; `type`: bgfx_uniform_type_t; num: uint16): bgfx_uniform_handle_t {.importc: "bgfx_create_uniform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create shader uniform parameter.
  ##
  ## **Parameters:**
  ## - `name` (in): Uniform name in shader.
  ## - `type` (in): Type of uniform (See: `bgfx_uniform_type_t`).
  ## - `num` (in): Number of elements in array.
  ##
  ## **Returns:**
  ## Handle to uniform object.
  ##
  ## **Remarks:**
  ## 1\. Uniform names are unique. It's valid to call `BGFX.create_uniform`
  ## multiple times with the same uniform name. The library will always
  ## return the same handle, but the handle reference count will be
  ## incremented. This means that the same number of `BGFX.destroy_uniform`
  ## must be called to properly destroy the uniform.
  ##
  ## 2\. Predefined uniforms (declared in `bgfx_shader.sh`):
  ## \- `u_viewRect vec4(x, y, width, height)` - view rectangle for current
  ## view, in pixels.
  ## \- `u_viewTexel vec4(1.0/width, 1.0/height, undef, undef)` - inverse
  ## width and height
  ## \- `u_view mat4` - view matrix
  ## \- `u_invView mat4` - inverted view matrix
  ## \- `u_proj mat4` - projection matrix
  ## \- `u_invProj mat4` - inverted projection matrix
  ## \- `u_viewProj mat4` - concatenated view projection matrix
  ## \- `u_invViewProj mat4` - concatenated inverted view projection matrix
  ## \- `u_model mat4[BGFX_CONFIG_MAX_BONES]` - array of model matrices.
  ## \- `u_modelView mat4` - concatenated model view matrix, only first
  ## model matrix from array is used.
  ## \- `u_invModelView mat4` - inverted concatenated model view matrix.
  ## \- `u_modelViewProj mat4` - concatenated model view projection matrix.
  ## \- `u_alphaRef float` - alpha reference value for alpha test.
proc create_uniform_with_freq*(_: type BGFX; name: cstring; freq: bgfx_uniform_freq_t; `type`: bgfx_uniform_type_t; num: uint16): bgfx_uniform_handle_t {.importc: "bgfx_create_uniform_with_freq", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create shader uniform parameter.
  ##
  ## **Parameters:**
  ## - `name` (in): Uniform name in shader.
  ## - `freq` (in): Uniform change frequency (See: `bgfx_uniform_freq_t`).
  ## - `type` (in): Type of uniform (See: `bgfx_uniform_type_t`).
  ## - `num` (in): Number of elements in array.
  ##
  ## **Returns:**
  ## Handle to uniform object.
  ##
  ## **Remarks:**
  ## 1\. Uniform names are unique. It's valid to call `BGFX.create_uniform`
  ## multiple times with the same uniform name. The library will always
  ## return the same handle, but the handle reference count will be
  ## incremented. This means that the same number of `BGFX.destroy_uniform`
  ## must be called to properly destroy the uniform.
  ##
  ## 2\. Predefined uniforms (declared in `bgfx_shader.sh`):
  ## \- `u_viewRect vec4(x, y, width, height)` - view rectangle for current
  ## view, in pixels.
  ## \- `u_viewTexel vec4(1.0/width, 1.0/height, undef, undef)` - inverse
  ## width and height
  ## \- `u_view mat4` - view matrix
  ## \- `u_invView mat4` - inverted view matrix
  ## \- `u_proj mat4` - projection matrix
  ## \- `u_invProj mat4` - inverted projection matrix
  ## \- `u_viewProj mat4` - concatenated view projection matrix
  ## \- `u_invViewProj mat4` - concatenated inverted view projection matrix
  ## \- `u_model mat4[BGFX_CONFIG_MAX_BONES]` - array of model matrices.
  ## \- `u_modelView mat4` - concatenated model view matrix, only first
  ## model matrix from array is used.
  ## \- `u_invModelView mat4` - inverted concatenated model view matrix.
  ## \- `u_modelViewProj mat4` - concatenated model view projection matrix.
  ## \- `u_alphaRef float` - alpha reference value for alpha test.
proc get_uniform_info*(_: type BGFX; handle: bgfx_uniform_handle_t; info: ptr bgfx_uniform_info_t) {.importc: "bgfx_get_uniform_info", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Retrieve uniform info.
  ##
  ## **Parameters:**
  ## - `handle` (in): Handle to uniform object.
  ## - `info` (out): Uniform info.
proc destroy_uniform*(_: type BGFX; handle: bgfx_uniform_handle_t) {.importc: "bgfx_destroy_uniform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy shader uniform parameter.
  ##
  ## **Parameters:**
  ## - `handle` (in): Handle to uniform object.
proc create_occlusion_query*(_: type BGFX): bgfx_occlusion_query_handle_t {.importc: "bgfx_create_occlusion_query", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Create occlusion query. Occlusion queries allow the GPU to determine
  ## if any pixels passed the depth test.
proc get_result*(_: type BGFX; handle: bgfx_occlusion_query_handle_t; result: ptr int32): bgfx_occlusion_query_result_t {.importc: "bgfx_get_result", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Retrieve occlusion query result from previous frame.
  ##
  ## **Parameters:**
  ## - `handle` (in): Handle to occlusion query object.
  ## - `result` (out): Number of pixels that passed test. This argument
  ##   can be `NULL` if result of occlusion query is not needed.
  ##
  ## **Returns:**
  ## Occlusion query result.
proc destroy_occlusion_query*(_: type BGFX; handle: bgfx_occlusion_query_handle_t) {.importc: "bgfx_destroy_occlusion_query", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Destroy occlusion query.
  ##
  ## **Parameters:**
  ## - `handle` (in): Handle to occlusion query object.
proc set_palette_color*(_: type BGFX; index: uint8; rgba: array[4, cfloat]) {.importc: "bgfx_set_palette_color", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set palette color value.
  ##
  ## **Parameters:**
  ## - `index` (in): Index into palette.
  ## - `rgba` (in): RGBA floating point values.
proc set_palette_color_rgba32f*(_: type BGFX; index: uint8; r: cfloat; g: cfloat; b: cfloat; a: cfloat) {.importc: "bgfx_set_palette_color_rgba32f", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set palette color value.
  ##
  ## **Parameters:**
  ## - `index` (in): Index into palette.
  ## - `r` (in): Red value (RGBA floating point values)
  ## - `g` (in): Green value (RGBA floating point values)
  ## - `b` (in): Blue value (RGBA floating point values)
  ## - `a` (in): Alpha value (RGBA floating point values)
proc set_palette_color_rgba8*(_: type BGFX; index: uint8; rgba: uint32) {.importc: "bgfx_set_palette_color_rgba8", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set palette color value.
  ##
  ## **Parameters:**
  ## - `index` (in): Index into palette.
  ## - `rgba` (in): Packed 32-bit RGBA value.
proc set_view_name*(_: type BGFX; id: bgfx_view_id_t; name: cstring; len: int32) {.importc: "bgfx_set_view_name", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view name.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `name` (in): View name.
  ## - `len` (in): View name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string.
  ##
  ## **Remarks:**
  ## This is debug only feature.
  ##
  ## In graphics debugger view name will appear as:
  ##
  ## "nnnc <view name>"
  ## \^  ^ ^
  ## \|  +--- compute (C)
  ## \+------ view id
proc set_view_rect*(_: type BGFX; id: bgfx_view_id_t; x: int16; y: int16; width: uint16; height: uint16) {.importc: "bgfx_set_view_rect", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view rectangle. Draw primitive outside view will be clipped.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `x` (in): Position x from the left corner of the window. Can be
  ##   negative to place view origin outside of the window.
  ## - `y` (in): Position y from the top corner of the window. Can be
  ##   negative to place view origin outside of the window.
  ## - `width` (in): Width of view port region.
  ## - `height` (in): Height of view port region.
proc set_view_rect_ratio*(_: type BGFX; id: bgfx_view_id_t; x: int16; y: int16; ratio: bgfx_backbuffer_ratio_t) {.importc: "bgfx_set_view_rect_ratio", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view rectangle. Draw primitive outside view will be clipped.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `x` (in): Position x from the left corner of the window. Can be
  ##   negative to place view origin outside of the window.
  ## - `y` (in): Position y from the top corner of the window. Can be
  ##   negative to place view origin outside of the window.
  ## - `ratio` (in): Width and height will be set in respect to back-buffer size.
  ##   See: `bgfx_backbuffer_ratio_t`.
proc set_view_scissor*(_: type BGFX; id: bgfx_view_id_t; x: uint16; y: uint16; width: uint16; height: uint16) {.importc: "bgfx_set_view_scissor", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view scissor. Draw primitive outside view will be clipped. When
  ## x, y, width and height are set to 0, scissor will be disabled.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `x` (in): Position x from the left corner of the window.
  ## - `y` (in): Position y from the top corner of the window.
  ## - `width` (in): Width of view scissor region.
  ## - `height` (in): Height of view scissor region.
proc set_view_clear*(_: type BGFX; id: bgfx_view_id_t; flags: uint16; rgba: uint32; depth: cfloat; stencil: uint8) {.importc: "bgfx_set_view_clear", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view clear flags.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `flags` (in): Clear flags. Use `BGFX_CLEAR_NONE` to remove any clear
  ##   operation. See: `BGFX_CLEAR_*`.
  ## - `rgba` (in): Color clear value.
  ## - `depth` (in): Depth clear value.
  ## - `stencil` (in): Stencil clear value.
proc set_view_clear_mrt*(_: type BGFX; id: bgfx_view_id_t; flags: uint16; depth: cfloat; stencil: uint8; c0: uint8; c1: uint8; c2: uint8; c3: uint8; c4: uint8; c5: uint8; c6: uint8; c7: uint8) {.importc: "bgfx_set_view_clear_mrt", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view clear flags with different clear color for each
  ## frame buffer texture. `BGFX.set_palette_color` must be used to set up a
  ## clear color palette.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `flags` (in): Clear flags. Use `BGFX_CLEAR_NONE` to remove any clear
  ##   operation. See: `BGFX_CLEAR_*`.
  ## - `depth` (in): Depth clear value.
  ## - `stencil` (in): Stencil clear value.
  ## - `c0` (in): Palette index for frame buffer attachment 0.
  ## - `c1` (in): Palette index for frame buffer attachment 1.
  ## - `c2` (in): Palette index for frame buffer attachment 2.
  ## - `c3` (in): Palette index for frame buffer attachment 3.
  ## - `c4` (in): Palette index for frame buffer attachment 4.
  ## - `c5` (in): Palette index for frame buffer attachment 5.
  ## - `c6` (in): Palette index for frame buffer attachment 6.
  ## - `c7` (in): Palette index for frame buffer attachment 7.
proc set_view_mode*(_: type BGFX; id: bgfx_view_id_t; mode: bgfx_view_mode_t) {.importc: "bgfx_set_view_mode", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view sorting mode.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `mode` (in): View sort mode. See `bgfx_view_mode_t`.
  ##
  ## **Remarks:**
  ## View mode must be set prior calling `BGFX.submit` for the view.
proc set_view_frame_buffer*(_: type BGFX; id: bgfx_view_id_t; handle: bgfx_frame_buffer_handle_t) {.importc: "bgfx_set_view_frame_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view frame buffer.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `handle` (in): Frame buffer handle. Passing `BGFX_INVALID_HANDLE` as
  ##   frame buffer handle will draw primitives from this view into
  ##   default back buffer.
  ##
  ## **Remarks:**
  ## Not persistent after `BGFX.reset` call.
proc set_view_transform*(_: type BGFX; id: bgfx_view_id_t; view: pointer; proj: pointer) {.importc: "bgfx_set_view_transform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view's view matrix and projection matrix,
  ## all draw primitives in this view will use these two matrices.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `view` (in): View matrix.
  ## - `proj` (in): Projection matrix.
proc set_view_order*(_: type BGFX; id: bgfx_view_id_t; num: uint16; order: ptr bgfx_view_id_t) {.importc: "bgfx_set_view_order", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Post submit view reordering.
  ##
  ## **Parameters:**
  ## - `id` (in): First view id.
  ## - `num` (in): Number of views to remap.
  ## - `order` (in): View remap id table. Passing `NULL` will reset view ids
  ##   to default state.
proc set_view_shading_rate*(_: type BGFX; id: bgfx_view_id_t; shadingRate: bgfx_shading_rate_t) {.importc: "bgfx_set_view_shading_rate", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set view shading rate.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `shadingRate` (in): Shading rate.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_VARIABLE_RATE_SHADING`.
proc reset_view*(_: type BGFX; id: bgfx_view_id_t) {.importc: "bgfx_reset_view", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Reset all view settings to default.
  ##
  ## **Parameters:**
  ## - `id` (in): id View id.
proc encoder_begin*(_: type BGFX; forceNewEncoder: bool): ptr bgfx_encoder_t {.importc: "bgfx_encoder_begin", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Begin submitting draw calls from thread. Obtains an encoder that can be
  ## used to submit draw calls, compute dispatches, and state changes.
  ##
  ## In multithreaded mode (`BGFX_CONFIG_MULTITHREADED=1`), multiple threads
  ## can each obtain their own encoder and submit draw calls in parallel.
  ## Each encoder writes into its own uniform buffer, so there is no
  ## contention between threads. The maximum number of simultaneous encoders
  ## is configured via `Limits.maxEncoders` in `bgfx_init_t` (default: 8).
  ##
  ## When called from the API thread (the thread that called `BGFX.init`)
  ## with `forceNewEncoder` set to `false`, the default internal encoder
  ## (encoder 0) is returned. This is the same encoder used by the legacy
  ## non-encoder API (`BGFX.set_state`, `BGFX.submit`, etc.). When called
  ## from a worker thread (or with `forceNewEncoder` set to `true`), a new
  ## encoder is allocated from the encoder pool.
  ##
  ## **Parameters:**
  ## - `forceNewEncoder` (in): Force allocation of a new encoder from the pool,
  ##   even when called from the API thread.
  ##
  ## **Returns:**
  ## Encoder.
  ##
  ## **Remarks:**
  ## The returned `Encoder` pointer is valid until `BGFX.end` is called
  ## with it. All encoders must be ended before `BGFX.frame` is called.
  ## If `BGFX.frame` is called while encoders are still active, it will
  ## wait for them to finish. Returns `NULL` if no encoder slots are
  ## available (all `maxEncoders` slots are in use).
  ## See also: `BGFX.end`, `BGFX.frame`.
proc encoder_end*(_: type BGFX; encoder: ptr bgfx_encoder_t) {.importc: "bgfx_encoder_end", cdecl, header: "bgfx/c99/bgfx.h".}
  ## End submitting draw calls from thread. Returns the encoder obtained from
  ## `BGFX.begin` back to the encoder pool.
  ##
  ## After this call the `Encoder` pointer is no longer valid and must not
  ## be used. The encoder's recorded draw calls and state changes are finalized
  ## and will be included in the next frame when `BGFX.frame` is called.
  ##
  ## **Parameters:**
  ## - `encoder` (in): Encoder.
  ##
  ## **Remarks:**
  ## Must be called from the same thread that called `BGFX.begin` for
  ## this encoder. All encoders must be ended before `BGFX.frame` is
  ## called. The default encoder (encoder 0, used by the legacy API) is
  ## managed internally and does not need to be passed to `BGFX.end`;
  ## passing it is harmless but has no effect.
  ## See also: `BGFX.begin`, `BGFX.frame`.
proc encoder_set_marker*(_: type BGFX; this: ptr bgfx_encoder_t; name: cstring; len: int32) {.importc: "bgfx_encoder_set_marker", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Sets a debug marker. This allows you to group graphics calls together for easy browsing in
  ## graphics debugging tools.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `name` (in): Marker name.
  ## - `len` (in): Marker name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string.
proc encoder_set_state*(_: type BGFX; this: ptr bgfx_encoder_t; state: uint64; rgba: uint32) {.importc: "bgfx_encoder_set_state", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set render states for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `state` (in): State flags. Default state for primitive type is
  ##   triangles. See: `BGFX_STATE_DEFAULT`.
  ##   \- `BGFX_STATE_DEPTH_TEST_*` - Depth test function.
  ##   \- `BGFX_STATE_BLEND_*` - See remark 1 about BGFX_STATE_BLEND_FUNC.
  ##   \- `BGFX_STATE_BLEND_EQUATION_*` - See remark 2.
  ##   \- `BGFX_STATE_CULL_*` - Backface culling mode.
  ##   \- `BGFX_STATE_WRITE_*` - Enable R, G, B, A or Z write.
  ##   \- `BGFX_STATE_MSAA` - Enable hardware multisample antialiasing.
  ##   \- `BGFX_STATE_PT_[TRISTRIP/LINES/POINTS]` - Primitive type.
  ## - `rgba` (in): Sets blend factor used by `BGFX_STATE_BLEND_FACTOR` and
  ##   `BGFX_STATE_BLEND_INV_FACTOR` blend modes.
  ##
  ## **Remarks:**
  ## 1\. To set up more complex states use:
  ## `BGFX_STATE_ALPHA_REF(_ref)`,
  ## `BGFX_STATE_POINT_SIZE(_size)`,
  ## `BGFX_STATE_BLEND_FUNC(_src, _dst)`,
  ## `BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)`,
  ## `BGFX_STATE_BLEND_EQUATION(_equation)`,
  ## `BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)`
  ## 2\. `BGFX_STATE_BLEND_EQUATION_ADD` is set when no other blend
  ## equation is specified.
proc encoder_set_condition*(_: type BGFX; this: ptr bgfx_encoder_t; handle: bgfx_occlusion_query_handle_t; visible: bool) {.importc: "bgfx_encoder_set_condition", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set condition for rendering.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `handle` (in): Occlusion query handle.
  ## - `visible` (in): Render if occlusion query is visible.
proc encoder_set_stencil*(_: type BGFX; this: ptr bgfx_encoder_t; fstencil: uint32; bstencil: uint32) {.importc: "bgfx_encoder_set_stencil", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set stencil test state.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `fstencil` (in): Front stencil state.
  ## - `bstencil` (in): Back stencil state. If back is set to `BGFX_STENCIL_NONE`
  ##   fstencil is applied to both front and back facing primitives.
proc encoder_set_scissor*(_: type BGFX; this: ptr bgfx_encoder_t; x: uint16; y: uint16; width: uint16; height: uint16): uint16 {.importc: "bgfx_encoder_set_scissor", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set scissor for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `x` (in): Position x from the left corner of the window.
  ## - `y` (in): Position y from the top corner of the window.
  ## - `width` (in): Width of view scissor region.
  ## - `height` (in): Height of view scissor region.
  ##
  ## **Returns:**
  ## Scissor cache index.
  ##
  ## **Remarks:**
  ## To scissor for all primitives in view see `BGFX.set_view_scissor`.
proc encoder_set_scissor_cached*(_: type BGFX; this: ptr bgfx_encoder_t; cache: uint16) {.importc: "bgfx_encoder_set_scissor_cached", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set scissor from cache for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `cache` (in): Index in scissor cache.
  ##
  ## **Remarks:**
  ## To scissor for all primitives in view see `BGFX.set_view_scissor`.
proc encoder_set_transform*(_: type BGFX; this: ptr bgfx_encoder_t; mtx: pointer; num: uint16): uint32 {.importc: "bgfx_encoder_set_transform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set model matrix for draw primitive. If it is not called,
  ## the model will be rendered with an identity model matrix.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `mtx` (in): Pointer to first matrix in array.
  ## - `num` (in): Number of matrices in array.
  ##
  ## **Returns:**
  ## Index into matrix cache in case the same model matrix has
  ## to be used for other draw primitive call.
proc encoder_set_transform_cached*(_: type BGFX; this: ptr bgfx_encoder_t; cache: uint32; num: uint16) {.importc: "bgfx_encoder_set_transform_cached", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set model matrix from matrix cache for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `cache` (in): Index in matrix cache.
  ## - `num` (in): Number of matrices from cache.
proc encoder_alloc_transform*(_: type BGFX; this: ptr bgfx_encoder_t; transform: ptr bgfx_transform_t; num: uint16): uint32 {.importc: "bgfx_encoder_alloc_transform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Reserve matrices in internal matrix cache.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `transform` (out): Pointer to `bgfx_transform_t` structure.
  ## - `num` (in): Number of matrices.
  ##
  ## **Returns:**
  ## Index in matrix cache.
  ##
  ## **Attention:**
  ## Pointer returned can be modified until `BGFX.frame` is called.
proc encoder_set_uniform*(_: type BGFX; this: ptr bgfx_encoder_t; handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.importc: "bgfx_encoder_set_uniform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set shader uniform parameter for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `handle` (in): Uniform.
  ## - `value` (in): Pointer to uniform data.
  ## - `num` (in): Number of elements. Passing `UINT16_MAX` will
  ##   use the num passed on uniform creation.
proc set_view_uniform*(_: type BGFX; id: bgfx_view_id_t; handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.importc: "bgfx_set_view_uniform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set shader uniform parameter for view.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `handle` (in): Uniform.
  ## - `value` (in): Pointer to uniform data.
  ## - `num` (in): Number of elements. Passing `UINT16_MAX` will
  ##   use the num passed on uniform creation.
  ##
  ## **Attention:**
  ## Uniform must be created with `BGFX_UNIFORM_FREQ_VIEW` argument.
proc set_frame_uniform*(_: type BGFX; handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.importc: "bgfx_set_frame_uniform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set shader uniform parameter for frame.
  ##
  ## **Parameters:**
  ## - `handle` (in): Uniform.
  ## - `value` (in): Pointer to uniform data.
  ## - `num` (in): Number of elements. Passing `UINT16_MAX` will
  ##   use the num passed on uniform creation.
  ##
  ## **Attention:**
  ## Uniform must be created with `BGFX_UNIFORM_FREQ_VIEW` argument.
proc encoder_set_index_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; handle: bgfx_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.importc: "bgfx_encoder_set_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set index buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `handle` (in): Index buffer.
  ## - `firstIndex` (in): First index to render.
  ## - `numIndices` (in): Number of indices to render.
proc encoder_set_dynamic_index_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; handle: bgfx_dynamic_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.importc: "bgfx_encoder_set_dynamic_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set index buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `handle` (in): Dynamic index buffer.
  ## - `firstIndex` (in): First index to render.
  ## - `numIndices` (in): Number of indices to render.
proc encoder_set_transient_index_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; tib: ptr bgfx_transient_index_buffer_t; firstIndex: uint32; numIndices: uint32) {.importc: "bgfx_encoder_set_transient_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set index buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `tib` (in): Transient index buffer.
  ## - `firstIndex` (in): First index to render.
  ## - `numIndices` (in): Number of indices to render.
proc encoder_set_vertex_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.importc: "bgfx_encoder_set_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
proc encoder_set_vertex_buffer_with_layout*(_: type BGFX; this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.importc: "bgfx_encoder_set_vertex_buffer_with_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
  ## - `layoutHandle` (in): Vertex layout for aliasing vertex buffer. If invalid
  ##   handle is used, vertex layout used for creation
  ##   of vertex buffer will be used.
proc encoder_set_dynamic_vertex_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.importc: "bgfx_encoder_set_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Dynamic vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
proc encoder_set_dynamic_vertex_buffer_with_layout*(_: type BGFX; this: ptr bgfx_encoder_t; stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.importc: "bgfx_encoder_set_dynamic_vertex_buffer_with_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Dynamic vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
  ## - `layoutHandle` (in): Vertex layout for aliasing vertex buffer. If invalid
  ##   handle is used, vertex layout used for creation
  ##   of vertex buffer will be used.
proc encoder_set_transient_vertex_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32) {.importc: "bgfx_encoder_set_transient_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stream` (in): Vertex stream.
  ## - `tvb` (in): Transient vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
proc encoder_set_transient_vertex_buffer_with_layout*(_: type BGFX; this: ptr bgfx_encoder_t; stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.importc: "bgfx_encoder_set_transient_vertex_buffer_with_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stream` (in): Vertex stream.
  ## - `tvb` (in): Transient vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
  ## - `layoutHandle` (in): Vertex layout for aliasing vertex buffer. If invalid
  ##   handle is used, vertex layout used for creation
  ##   of vertex buffer will be used.
proc encoder_set_vertex_count*(_: type BGFX; this: ptr bgfx_encoder_t; numVertices: uint32) {.importc: "bgfx_encoder_set_vertex_count", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set number of vertices for auto generated vertices use in conjunction
  ## with gl_VertexID.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `numVertices` (in): Number of vertices.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_VERTEX_ID`.
proc encoder_set_instance_data_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; idb: ptr bgfx_instance_data_buffer_t; start: uint32; num: uint32) {.importc: "bgfx_encoder_set_instance_data_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set instance data buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `idb` (in): Transient instance data buffer.
  ## - `start` (in): First instance data.
  ## - `num` (in): Number of data instances.
proc encoder_set_instance_data_from_vertex_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.importc: "bgfx_encoder_set_instance_data_from_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set instance data buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `handle` (in): Vertex buffer.
  ## - `startVertex` (in): First instance data.
  ## - `num` (in): Number of data instances.
proc encoder_set_instance_data_from_dynamic_vertex_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.importc: "bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set instance data buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `handle` (in): Dynamic vertex buffer.
  ## - `startVertex` (in): First instance data.
  ## - `num` (in): Number of data instances.
proc encoder_set_instance_count*(_: type BGFX; this: ptr bgfx_encoder_t; numInstances: uint32) {.importc: "bgfx_encoder_set_instance_count", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set number of instances for auto generated instances use in conjunction
  ## with gl_InstanceID.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `numInstances` (in): Number of instances.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_VERTEX_ID`.
proc encoder_set_texture*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; flags: uint32) {.importc: "bgfx_encoder_set_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set texture stage for draw primitive.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Texture unit.
  ## - `sampler` (in): Program sampler.
  ## - `handle` (in): Texture handle.
  ## - `flags` (in): Texture sampling mode. Default value UINT32_MAX uses
  ##   texture sampling settings from the texture.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
proc encoder_set_texture_view*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; firstMip: uint8; numMips: uint8; flags: uint32) {.importc: "bgfx_encoder_set_texture_view", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set texture stage for draw primitive, selecting a sub-range of the
  ## texture's array layers and mip levels.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Texture unit.
  ## - `sampler` (in): Program sampler.
  ## - `handle` (in): Texture handle.
  ## - `firstLayer` (in): First array layer.
  ## - `numLayers` (in): Number of array layers.
  ## - `firstMip` (in): First (most detailed) mip level.
  ## - `numMips` (in): Number of mip levels.
  ## - `flags` (in): Texture sampling mode. Default value UINT32_MAX uses
  ##   texture sampling settings from the texture.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
proc encoder_touch*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t) {.importc: "bgfx_encoder_touch", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit an empty primitive for rendering. Uniforms and draw state
  ## will be applied but no geometry will be submitted. Useful in cases
  ## when no other draw/compute primitive is submitted to view, but it's
  ## desired to execute clear view.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ##
  ## **Remarks:**
  ## These empty draw calls will sort before ordinary draw calls.
proc encoder_submit*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; depth: uint32; flags: uint8) {.importc: "bgfx_encoder_submit", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive for rendering.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
proc encoder_submit_occlusion_query*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; occlusionQuery: bgfx_occlusion_query_handle_t; depth: uint32; flags: uint8) {.importc: "bgfx_encoder_submit_occlusion_query", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive with occlusion query for rendering.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `occlusionQuery` (in): Occlusion query.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
proc encoder_submit_indirect*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; depth: uint32; flags: uint8) {.importc: "bgfx_encoder_submit_indirect", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive for rendering with index and instance data info from
  ## indirect buffer.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `indirectHandle` (in): Indirect buffer.
  ## - `start` (in): First element in indirect buffer.
  ## - `num` (in): Number of draws.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_DRAW_INDIRECT`.
proc encoder_submit_indirect_count*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; numHandle: bgfx_index_buffer_handle_t; numIndex: uint32; numMax: uint32; depth: uint32; flags: uint8) {.importc: "bgfx_encoder_submit_indirect_count", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive for rendering with index and instance data info and
  ## draw count from indirect buffers.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `indirectHandle` (in): Indirect buffer.
  ## - `start` (in): First element in indirect buffer.
  ## - `numHandle` (in): Buffer for number of draws. Must be
  ##   created with `BGFX_BUFFER_INDEX32` and `BGFX_BUFFER_DRAW_INDIRECT`.
  ## - `numIndex` (in): Element in number buffer.
  ## - `numMax` (in): Max number of draws.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_DRAW_INDIRECT_COUNT`.
proc encoder_set_compute_index_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_index_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_encoder_set_compute_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute index buffer.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Index buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc encoder_set_compute_vertex_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_vertex_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_encoder_set_compute_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute vertex buffer.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Vertex buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc encoder_set_compute_dynamic_index_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_dynamic_index_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_encoder_set_compute_dynamic_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute dynamic index buffer.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Dynamic index buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc encoder_set_compute_dynamic_vertex_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_encoder_set_compute_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute dynamic vertex buffer.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Dynamic vertex buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc encoder_set_compute_indirect_buffer*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_indirect_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_encoder_set_compute_indirect_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute indirect buffer.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Indirect buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc encoder_set_image*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_texture_handle_t; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.importc: "bgfx_encoder_set_image", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute image from texture.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Texture handle.
  ## - `mip` (in): Mip level.
  ## - `access` (in): Image access. See `bgfx_access_t`.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
proc encoder_set_image_view*(_: type BGFX; this: ptr bgfx_encoder_t; stage: uint8; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.importc: "bgfx_encoder_set_image_view", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute image stage for draw primitive, selecting a sub-range of the
  ## texture's array layers and mip levels.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Texture handle.
  ## - `firstLayer` (in): First array layer.
  ## - `numLayers` (in): Number of array layers.
  ## - `mip` (in): Mip level.
  ## - `access` (in): Image access. See `bgfx_access_t`.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
proc encoder_dispatch*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; numX: uint32; numY: uint32; numZ: uint32; flags: uint8) {.importc: "bgfx_encoder_dispatch", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Dispatch compute.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ## - `program` (in): Compute program.
  ## - `numX` (in): Number of groups X.
  ## - `numY` (in): Number of groups Y.
  ## - `numZ` (in): Number of groups Z.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
proc encoder_dispatch_indirect*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; flags: uint8) {.importc: "bgfx_encoder_dispatch_indirect", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Dispatch compute indirect.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ## - `program` (in): Compute program.
  ## - `indirectHandle` (in): Indirect buffer.
  ## - `start` (in): First element in indirect buffer.
  ## - `num` (in): Number of dispatches.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
proc encoder_discard*(_: type BGFX; this: ptr bgfx_encoder_t; flags: uint8) {.importc: "bgfx_encoder_discard", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Discard previously set state for draw or compute call.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
proc encoder_blit*(_: type BGFX; this: ptr bgfx_encoder_t; id: bgfx_view_id_t; dst: bgfx_texture_handle_t; dstMip: uint8; dstX: uint16; dstY: uint16; dstZ: uint16; src: bgfx_texture_handle_t; srcMip: uint8; srcX: uint16; srcY: uint16; srcZ: uint16; width: uint16; height: uint16; depth: uint16) {.importc: "bgfx_encoder_blit", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Blit 2D texture region between two 2D textures.
  ##
  ## **Parameters:**
  ## - `this` (in): Encoder instance.
  ## - `id` (in): View id.
  ## - `dst` (in): Destination texture handle.
  ## - `dstMip` (in): Destination texture mip level.
  ## - `dstX` (in): Destination texture X position.
  ## - `dstY` (in): Destination texture Y position.
  ## - `dstZ` (in): If texture is 2D this argument should be 0. If destination texture is cube
  ##   this argument represents destination texture cube face. For 3D texture this argument
  ##   represents destination texture Z position.
  ## - `src` (in): Source texture handle.
  ## - `srcMip` (in): Source texture mip level.
  ## - `srcX` (in): Source texture X position.
  ## - `srcY` (in): Source texture Y position.
  ## - `srcZ` (in): If texture is 2D this argument should be 0. If source texture is cube
  ##   this argument represents source texture cube face. For 3D texture this argument
  ##   represents source texture Z position.
  ## - `width` (in): Width of region.
  ## - `height` (in): Height of region.
  ## - `depth` (in): If texture is 3D this argument represents depth of region, otherwise it's
  ##   unused.
  ##
  ## **Attention:**
  ## Destination texture must be created with `BGFX_TEXTURE_BLIT_DST` flag.
  ##
  ## Availability depends on: `BGFX_CAPS_TEXTURE_BLIT`.
proc request_screen_shot*(_: type BGFX; handle: bgfx_frame_buffer_handle_t; filePath: cstring) {.importc: "bgfx_request_screen_shot", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Request screen shot of window back buffer.
  ##
  ## **Parameters:**
  ## - `handle` (in): Frame buffer handle. If handle is `BGFX_INVALID_HANDLE` request will be
  ##   made for main window back buffer.
  ## - `filePath` (in): Will be passed to `bgfx_callback_interface_t.screen_shot` callback.
  ##
  ## **Remarks:**
  ## `bgfx_callback_interface_t.screen_shot` must be implemented.
  ##
  ## **Attention:**
  ## Frame buffer handle must be created with OS' target native window handle.
proc render_frame*(_: type BGFX; msecs: int32): bgfx_render_frame_t {.importc: "bgfx_render_frame", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Render frame. Executes the actual GPU rendering work for one frame.
  ##
  ## In the default **multithreaded** configuration, `BGFX.render_frame` runs
  ## on the **render thread** while `BGFX.frame` runs on the **API thread**.
  ## Their interaction is as follows:
  ##
  ## 1\. The render thread calls `BGFX.render_frame`, which blocks waiting
  ## for the API thread to signal that a new frame is ready.
  ## 2\. On the API thread, `BGFX.frame` finishes building the frame,
  ## swaps internal submit/render buffers, and signals the render thread.
  ## 3\. `BGFX.render_frame` wakes up, executes pre-render commands,
  ## submits GPU draw calls, executes post-render commands, flips the
  ## back buffer, then signals back to the API thread that rendering
  ## is complete.
  ## 4\. The API thread's next `BGFX.frame` call waits for this completion
  ## signal before swapping buffers again.
  ##
  ## This double-buffered semaphore handshake allows the API thread and
  ## render thread to run in parallel, overlapping CPU frame building with
  ## GPU rendering.
  ##
  ## **Parameters:**
  ## - `msecs` (in): Timeout in milliseconds.
  ##
  ## **Returns:**
  ## Current renderer context state. See: `bgfx_render_frame_t`.
  ##
  ## **Attention:**
  ## `BGFX.render_frame` is a blocking call. It waits for
  ## `BGFX.frame` to be called from the API thread to process the frame.
  ## If a timeout value is passed, the call will return
  ## `BGFX_RENDER_FRAME_TIMEOUT` even if `BGFX.frame` has not been called.
  ## A value of -1 (default) means wait indefinitely (up to
  ## `BGFX_CONFIG_API_SEMAPHORE_TIMEOUT`).
  ##
  ## **Warning:**
  ## This call should only be used on platforms that don't allow
  ## creating a separate rendering thread. If it is called before
  ## `BGFX.init`, the internal render thread won't be created by the
  ## `BGFX.init` call, and the user is responsible for calling
  ## `BGFX.render_frame` on the render thread each frame. If both
  ## `BGFX.render_frame` and `BGFX.init` are called from the same
  ## thread, bgfx operates in single-threaded mode and `BGFX.frame`
  ## will internally invoke `BGFX.render_frame` automatically.
  ## See also: `BGFX.frame`.
proc set_platform_data*(_: type BGFX; data: ptr bgfx_platform_data_t) {.importc: "bgfx_set_platform_data", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set platform data.
  ##
  ## **Parameters:**
  ## - `data` (in): Platform data.
  ##
  ## **Warning:**
  ## Must be called before `BGFX.init`.
proc get_internal_data*(_: type BGFX): ptr bgfx_internal_data_t {.importc: "bgfx_get_internal_data", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Get internal data for interop.
  ##
  ## **Attention:**
  ## It's expected you understand some bgfx internals before you
  ## use this call.
  ##
  ## **Warning:**
  ## Must be called only on render thread.
proc override_internal_texture_ptr*(_: type BGFX; handle: bgfx_texture_handle_t; `ptr`: uint; layerIndex: uint16): uint {.importc: "bgfx_override_internal_texture_ptr", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Override internal texture with externally created texture. Previously
  ## created internal texture will released.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `ptr` (in): Native API pointer to texture.
  ## - `layerIndex` (in): Layer index for texture arrays (only implemented for D3D11).
  ##
  ## **Returns:**
  ## Native API pointer to texture. If result is 0, texture is not created
  ## yet from the main thread.
  ##
  ## **Attention:**
  ## It's expected you understand some bgfx internals before you
  ## use this call.
  ##
  ## **Warning:**
  ## Must be called only on render thread.
proc override_internal_texture*(_: type BGFX; handle: bgfx_texture_handle_t; width: uint16; height: uint16; numMips: uint8; format: bgfx_texture_format_t; flags: uint64): uint {.importc: "bgfx_override_internal_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Override internal texture by creating new texture. Previously created
  ## internal texture will released.
  ##
  ## **Parameters:**
  ## - `handle` (in): Texture handle.
  ## - `width` (in): Width.
  ## - `height` (in): Height.
  ## - `numMips` (in): Number of mip-maps.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
  ## - `flags` (in): Texture creation (see `BGFX_TEXTURE_*`.), and sampler (see `BGFX_SAMPLER_*`)
  ##   flags. Default texture sampling mode is linear, and wrap mode is repeat.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
  ##
  ## **Returns:**
  ## Native API pointer to texture. If result is 0, texture is not created yet from the
  ## main thread.
  ##
  ## Native API pointer to texture. If result is 0, texture is not created
  ## yet from the main thread.
  ##
  ## **Attention:**
  ## It's expected you understand some bgfx internals before you
  ## use this call.
  ##
  ## **Warning:**
  ## Must be called only on render thread.
proc set_marker*(_: type BGFX; name: cstring; len: int32) {.importc: "bgfx_set_marker", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Sets a debug marker. This allows you to group graphics calls together for easy browsing in
  ## graphics debugging tools.
  ##
  ## **Parameters:**
  ## - `name` (in): Marker name.
  ## - `len` (in): Marker name length (if length is INT32_MAX, it's expected
  ##   that name is zero terminated string.
proc set_state*(_: type BGFX; state: uint64; rgba: uint32) {.importc: "bgfx_set_state", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set render states for draw primitive.
  ##
  ## **Parameters:**
  ## - `state` (in): State flags. Default state for primitive type is
  ##   triangles. See: `BGFX_STATE_DEFAULT`.
  ##   \- `BGFX_STATE_DEPTH_TEST_*` - Depth test function.
  ##   \- `BGFX_STATE_BLEND_*` - See remark 1 about BGFX_STATE_BLEND_FUNC.
  ##   \- `BGFX_STATE_BLEND_EQUATION_*` - See remark 2.
  ##   \- `BGFX_STATE_CULL_*` - Backface culling mode.
  ##   \- `BGFX_STATE_WRITE_*` - Enable R, G, B, A or Z write.
  ##   \- `BGFX_STATE_MSAA` - Enable hardware multisample antialiasing.
  ##   \- `BGFX_STATE_PT_[TRISTRIP/LINES/POINTS]` - Primitive type.
  ## - `rgba` (in): Sets blend factor used by `BGFX_STATE_BLEND_FACTOR` and
  ##   `BGFX_STATE_BLEND_INV_FACTOR` blend modes.
  ##
  ## **Remarks:**
  ## 1\. To set up more complex states use:
  ## `BGFX_STATE_ALPHA_REF(_ref)`,
  ## `BGFX_STATE_POINT_SIZE(_size)`,
  ## `BGFX_STATE_BLEND_FUNC(_src, _dst)`,
  ## `BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)`,
  ## `BGFX_STATE_BLEND_EQUATION(_equation)`,
  ## `BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)`
  ## 2\. `BGFX_STATE_BLEND_EQUATION_ADD` is set when no other blend
  ## equation is specified.
proc set_condition*(_: type BGFX; handle: bgfx_occlusion_query_handle_t; visible: bool) {.importc: "bgfx_set_condition", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set condition for rendering.
  ##
  ## **Parameters:**
  ## - `handle` (in): Occlusion query handle.
  ## - `visible` (in): Render if occlusion query is visible.
proc set_stencil*(_: type BGFX; fstencil: uint32; bstencil: uint32) {.importc: "bgfx_set_stencil", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set stencil test state.
  ##
  ## **Parameters:**
  ## - `fstencil` (in): Front stencil state.
  ## - `bstencil` (in): Back stencil state. If back is set to `BGFX_STENCIL_NONE`
  ##   fstencil is applied to both front and back facing primitives.
proc set_scissor*(_: type BGFX; x: uint16; y: uint16; width: uint16; height: uint16): uint16 {.importc: "bgfx_set_scissor", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set scissor for draw primitive.
  ##
  ## **Parameters:**
  ## - `x` (in): Position x from the left corner of the window.
  ## - `y` (in): Position y from the top corner of the window.
  ## - `width` (in): Width of view scissor region.
  ## - `height` (in): Height of view scissor region.
  ##
  ## **Returns:**
  ## Scissor cache index.
  ##
  ## **Remarks:**
  ## To scissor for all primitives in view see `BGFX.set_view_scissor`.
proc set_scissor_cached*(_: type BGFX; cache: uint16) {.importc: "bgfx_set_scissor_cached", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set scissor from cache for draw primitive.
  ##
  ## **Parameters:**
  ## - `cache` (in): Index in scissor cache.
  ##
  ## **Remarks:**
  ## To scissor for all primitives in view see `BGFX.set_view_scissor`.
proc set_transform*(_: type BGFX; mtx: pointer; num: uint16): uint32 {.importc: "bgfx_set_transform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set model matrix for draw primitive. If it is not called,
  ## the model will be rendered with an identity model matrix.
  ##
  ## **Parameters:**
  ## - `mtx` (in): Pointer to first matrix in array.
  ## - `num` (in): Number of matrices in array.
  ##
  ## **Returns:**
  ## Index into matrix cache in case the same model matrix has
  ## to be used for other draw primitive call.
proc set_transform_cached*(_: type BGFX; cache: uint32; num: uint16) {.importc: "bgfx_set_transform_cached", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set model matrix from matrix cache for draw primitive.
  ##
  ## **Parameters:**
  ## - `cache` (in): Index in matrix cache.
  ## - `num` (in): Number of matrices from cache.
proc alloc_transform*(_: type BGFX; transform: ptr bgfx_transform_t; num: uint16): uint32 {.importc: "bgfx_alloc_transform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Reserve matrices in internal matrix cache.
  ##
  ## **Parameters:**
  ## - `transform` (out): Pointer to `bgfx_transform_t` structure.
  ## - `num` (in): Number of matrices.
  ##
  ## **Returns:**
  ## Index in matrix cache.
  ##
  ## **Attention:**
  ## Pointer returned can be modified until `BGFX.frame` is called.
proc set_uniform*(_: type BGFX; handle: bgfx_uniform_handle_t; value: pointer; num: uint16) {.importc: "bgfx_set_uniform", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set shader uniform parameter for draw primitive.
  ##
  ## **Parameters:**
  ## - `handle` (in): Uniform.
  ## - `value` (in): Pointer to uniform data.
  ## - `num` (in): Number of elements. Passing `UINT16_MAX` will
  ##   use the num passed on uniform creation.
proc set_index_buffer*(_: type BGFX; handle: bgfx_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.importc: "bgfx_set_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set index buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `handle` (in): Index buffer.
  ## - `firstIndex` (in): First index to render.
  ## - `numIndices` (in): Number of indices to render.
proc set_dynamic_index_buffer*(_: type BGFX; handle: bgfx_dynamic_index_buffer_handle_t; firstIndex: uint32; numIndices: uint32) {.importc: "bgfx_set_dynamic_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set index buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `handle` (in): Dynamic index buffer.
  ## - `firstIndex` (in): First index to render.
  ## - `numIndices` (in): Number of indices to render.
proc set_transient_index_buffer*(_: type BGFX; tib: ptr bgfx_transient_index_buffer_t; firstIndex: uint32; numIndices: uint32) {.importc: "bgfx_set_transient_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set index buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `tib` (in): Transient index buffer.
  ## - `firstIndex` (in): First index to render.
  ## - `numIndices` (in): Number of indices to render.
proc set_vertex_buffer*(_: type BGFX; stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.importc: "bgfx_set_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
proc set_vertex_buffer_with_layout*(_: type BGFX; stream: uint8; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.importc: "bgfx_set_vertex_buffer_with_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
  ## - `layoutHandle` (in): Vertex layout for aliasing vertex buffer. If invalid
  ##   handle is used, vertex layout used for creation
  ##   of vertex buffer will be used.
proc set_dynamic_vertex_buffer*(_: type BGFX; stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32) {.importc: "bgfx_set_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Dynamic vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
proc set_dynamic_vertex_buffer_with_layout*(_: type BGFX; stream: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.importc: "bgfx_set_dynamic_vertex_buffer_with_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `stream` (in): Vertex stream.
  ## - `handle` (in): Dynamic vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
  ## - `layoutHandle` (in): Vertex layout for aliasing vertex buffer. If invalid
  ##   handle is used, vertex layout used for creation
  ##   of vertex buffer will be used.
proc set_transient_vertex_buffer*(_: type BGFX; stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32) {.importc: "bgfx_set_transient_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `stream` (in): Vertex stream.
  ## - `tvb` (in): Transient vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
proc set_transient_vertex_buffer_with_layout*(_: type BGFX; stream: uint8; tvb: ptr bgfx_transient_vertex_buffer_t; startVertex: uint32; numVertices: uint32; layoutHandle: bgfx_vertex_layout_handle_t) {.importc: "bgfx_set_transient_vertex_buffer_with_layout", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set vertex buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `stream` (in): Vertex stream.
  ## - `tvb` (in): Transient vertex buffer.
  ## - `startVertex` (in): First vertex to render.
  ## - `numVertices` (in): Number of vertices to render.
  ## - `layoutHandle` (in): Vertex layout for aliasing vertex buffer. If invalid
  ##   handle is used, vertex layout used for creation
  ##   of vertex buffer will be used.
proc set_vertex_count*(_: type BGFX; numVertices: uint32) {.importc: "bgfx_set_vertex_count", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set number of vertices for auto generated vertices use in conjunction
  ## with gl_VertexID.
  ##
  ## **Parameters:**
  ## - `numVertices` (in): Number of vertices.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_VERTEX_ID`.
proc set_instance_data_buffer*(_: type BGFX; idb: ptr bgfx_instance_data_buffer_t; start: uint32; num: uint32) {.importc: "bgfx_set_instance_data_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set instance data buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `idb` (in): Transient instance data buffer.
  ## - `start` (in): First instance data.
  ## - `num` (in): Number of data instances.
proc set_instance_data_from_vertex_buffer*(_: type BGFX; handle: bgfx_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.importc: "bgfx_set_instance_data_from_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set instance data buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `handle` (in): Vertex buffer.
  ## - `startVertex` (in): First instance data.
  ## - `num` (in): Number of data instances.
proc set_instance_data_from_dynamic_vertex_buffer*(_: type BGFX; handle: bgfx_dynamic_vertex_buffer_handle_t; startVertex: uint32; num: uint32) {.importc: "bgfx_set_instance_data_from_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set instance data buffer for draw primitive.
  ##
  ## **Parameters:**
  ## - `handle` (in): Dynamic vertex buffer.
  ## - `startVertex` (in): First instance data.
  ## - `num` (in): Number of data instances.
proc set_instance_count*(_: type BGFX; numInstances: uint32) {.importc: "bgfx_set_instance_count", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set number of instances for auto generated instances use in conjunction
  ## with gl_InstanceID.
  ##
  ## **Parameters:**
  ## - `numInstances` (in): Number of instances.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_VERTEX_ID`.
proc set_texture*(_: type BGFX; stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; flags: uint32) {.importc: "bgfx_set_texture", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set texture stage for draw primitive.
  ##
  ## **Parameters:**
  ## - `stage` (in): Texture unit.
  ## - `sampler` (in): Program sampler.
  ## - `handle` (in): Texture handle.
  ## - `flags` (in): Texture sampling mode. Default value UINT32_MAX uses
  ##   texture sampling settings from the texture.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
proc set_texture_view*(_: type BGFX; stage: uint8; sampler: bgfx_uniform_handle_t; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; firstMip: uint8; numMips: uint8; flags: uint32) {.importc: "bgfx_set_texture_view", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set texture stage for draw primitive, selecting a sub-range of the
  ## texture's array layers and mip levels.
  ##
  ## **Parameters:**
  ## - `stage` (in): Texture unit.
  ## - `sampler` (in): Program sampler.
  ## - `handle` (in): Texture handle.
  ## - `firstLayer` (in): First array layer.
  ## - `numLayers` (in): Number of array layers.
  ## - `firstMip` (in): First (most detailed) mip level.
  ## - `numMips` (in): Number of mip levels.
  ## - `flags` (in): Texture sampling mode. Default value UINT32_MAX uses
  ##   texture sampling settings from the texture.
  ##   \- `BGFX_SAMPLER_[U/V/W]_[MIRROR/CLAMP]` - Mirror or clamp to edge wrap
  ##   mode.
  ##   \- `BGFX_SAMPLER_[MIN/MAG/MIP]_[POINT/ANISOTROPIC]` - Point or anisotropic
  ##   sampling.
proc touch*(_: type BGFX; id: bgfx_view_id_t) {.importc: "bgfx_touch", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit an empty primitive for rendering. Uniforms and draw state
  ## will be applied but no geometry will be submitted.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ##
  ## **Remarks:**
  ## These empty draw calls will sort before ordinary draw calls.
proc submit*(_: type BGFX; id: bgfx_view_id_t; program: bgfx_program_handle_t; depth: uint32; flags: uint8) {.importc: "bgfx_submit", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive for rendering.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Which states to discard for next draw. See `BGFX_DISCARD_*`.
proc submit_occlusion_query*(_: type BGFX; id: bgfx_view_id_t; program: bgfx_program_handle_t; occlusionQuery: bgfx_occlusion_query_handle_t; depth: uint32; flags: uint8) {.importc: "bgfx_submit_occlusion_query", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive with occlusion query for rendering.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `occlusionQuery` (in): Occlusion query.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Which states to discard for next draw. See `BGFX_DISCARD_*`.
proc submit_indirect*(_: type BGFX; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; depth: uint32; flags: uint8) {.importc: "bgfx_submit_indirect", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive for rendering with index and instance data info from
  ## indirect buffer.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `indirectHandle` (in): Indirect buffer.
  ## - `start` (in): First element in indirect buffer.
  ## - `num` (in): Number of draws.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Which states to discard for next draw. See `BGFX_DISCARD_*`.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_DRAW_INDIRECT`.
proc submit_indirect_count*(_: type BGFX; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; numHandle: bgfx_index_buffer_handle_t; numIndex: uint32; numMax: uint32; depth: uint32; flags: uint8) {.importc: "bgfx_submit_indirect_count", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Submit primitive for rendering with index and instance data info and
  ## draw count from indirect buffers.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `program` (in): Program.
  ## - `indirectHandle` (in): Indirect buffer.
  ## - `start` (in): First element in indirect buffer.
  ## - `numHandle` (in): Buffer for number of draws. Must be
  ##   created with `BGFX_BUFFER_INDEX32` and `BGFX_BUFFER_DRAW_INDIRECT`.
  ## - `numIndex` (in): Element in number buffer.
  ## - `numMax` (in): Max number of draws.
  ## - `depth` (in): Depth for sorting.
  ## - `flags` (in): Which states to discard for next draw. See `BGFX_DISCARD_*`.
  ##
  ## **Attention:**
  ## Availability depends on: `BGFX_CAPS_DRAW_INDIRECT_COUNT`.
proc set_compute_index_buffer*(_: type BGFX; stage: uint8; handle: bgfx_index_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_set_compute_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute index buffer.
  ##
  ## **Parameters:**
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Index buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc set_compute_vertex_buffer*(_: type BGFX; stage: uint8; handle: bgfx_vertex_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_set_compute_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute vertex buffer.
  ##
  ## **Parameters:**
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Vertex buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc set_compute_dynamic_index_buffer*(_: type BGFX; stage: uint8; handle: bgfx_dynamic_index_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_set_compute_dynamic_index_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute dynamic index buffer.
  ##
  ## **Parameters:**
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Dynamic index buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc set_compute_dynamic_vertex_buffer*(_: type BGFX; stage: uint8; handle: bgfx_dynamic_vertex_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_set_compute_dynamic_vertex_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute dynamic vertex buffer.
  ##
  ## **Parameters:**
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Dynamic vertex buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc set_compute_indirect_buffer*(_: type BGFX; stage: uint8; handle: bgfx_indirect_buffer_handle_t; access: bgfx_access_t) {.importc: "bgfx_set_compute_indirect_buffer", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute indirect buffer.
  ##
  ## **Parameters:**
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Indirect buffer handle.
  ## - `access` (in): Buffer access. See `bgfx_access_t`.
proc set_image*(_: type BGFX; stage: uint8; handle: bgfx_texture_handle_t; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.importc: "bgfx_set_image", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute image from texture.
  ##
  ## **Parameters:**
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Texture handle.
  ## - `mip` (in): Mip level.
  ## - `access` (in): Image access. See `bgfx_access_t`.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
proc set_image_view*(_: type BGFX; stage: uint8; handle: bgfx_texture_handle_t; firstLayer: uint16; numLayers: uint16; mip: uint8; access: bgfx_access_t; format: bgfx_texture_format_t) {.importc: "bgfx_set_image_view", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Set compute image stage for draw primitive, selecting a sub-range of the
  ## texture's array layers and mip levels.
  ##
  ## **Parameters:**
  ## - `stage` (in): Compute stage.
  ## - `handle` (in): Texture handle.
  ## - `firstLayer` (in): First array layer.
  ## - `numLayers` (in): Number of array layers.
  ## - `mip` (in): Mip level.
  ## - `access` (in): Image access. See `bgfx_access_t`.
  ## - `format` (in): Texture format. See: `bgfx_texture_format_t`.
proc dispatch*(_: type BGFX; id: bgfx_view_id_t; program: bgfx_program_handle_t; numX: uint32; numY: uint32; numZ: uint32; flags: uint8) {.importc: "bgfx_dispatch", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Dispatch compute.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `program` (in): Compute program.
  ## - `numX` (in): Number of groups X.
  ## - `numY` (in): Number of groups Y.
  ## - `numZ` (in): Number of groups Z.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
proc dispatch_indirect*(_: type BGFX; id: bgfx_view_id_t; program: bgfx_program_handle_t; indirectHandle: bgfx_indirect_buffer_handle_t; start: uint32; num: uint32; flags: uint8) {.importc: "bgfx_dispatch_indirect", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Dispatch compute indirect.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `program` (in): Compute program.
  ## - `indirectHandle` (in): Indirect buffer.
  ## - `start` (in): First element in indirect buffer.
  ## - `num` (in): Number of dispatches.
  ## - `flags` (in): Discard or preserve states. See `BGFX_DISCARD_*`.
proc `discard`*(_: type BGFX; flags: uint8) {.importc: "bgfx_discard", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Discard previously set state for draw or compute call.
  ##
  ## **Parameters:**
  ## - `flags` (in): Draw/compute states to discard.
proc blit*(_: type BGFX; id: bgfx_view_id_t; dst: bgfx_texture_handle_t; dstMip: uint8; dstX: uint16; dstY: uint16; dstZ: uint16; src: bgfx_texture_handle_t; srcMip: uint8; srcX: uint16; srcY: uint16; srcZ: uint16; width: uint16; height: uint16; depth: uint16) {.importc: "bgfx_blit", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Blit 2D texture region between two 2D textures.
  ##
  ## **Parameters:**
  ## - `id` (in): View id.
  ## - `dst` (in): Destination texture handle.
  ## - `dstMip` (in): Destination texture mip level.
  ## - `dstX` (in): Destination texture X position.
  ## - `dstY` (in): Destination texture Y position.
  ## - `dstZ` (in): If texture is 2D this argument should be 0. If destination texture is cube
  ##   this argument represents destination texture cube face. For 3D texture this argument
  ##   represents destination texture Z position.
  ## - `src` (in): Source texture handle.
  ## - `srcMip` (in): Source texture mip level.
  ## - `srcX` (in): Source texture X position.
  ## - `srcY` (in): Source texture Y position.
  ## - `srcZ` (in): If texture is 2D this argument should be 0. If source texture is cube
  ##   this argument represents source texture cube face. For 3D texture this argument
  ##   represents source texture Z position.
  ## - `width` (in): Width of region.
  ## - `height` (in): Height of region.
  ## - `depth` (in): If texture is 3D this argument represents depth of region, otherwise it's
  ##   unused.
  ##
  ## **Attention:**
  ## Destination texture must be created with `BGFX_TEXTURE_BLIT_DST` flag.
  ##
  ## Availability depends on: `BGFX_CAPS_TEXTURE_BLIT`.
proc get_interface*(_: type BGFX; version: uint32): ptr bgfx_interface_vtbl_t {.importc: "bgfx_get_interface", cdecl, header: "bgfx/c99/bgfx.h".}
  ## Return the C99 interface vtable for a matching API version.
  ##
  ## **Parameters:**
  ## - `version` (in): Requested `BGFX_API_VERSION` value.
  ##
  ## **Returns:**
  ## Interface vtable, or `nil` when `version` does not match.

# Compatibility aliases for the original generated names
template bgfx_attachment_init*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.attachment_init(args)

template bgfx_vertex_layout_begin*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_begin(args)

template bgfx_vertex_layout_add*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_add(args)

template bgfx_vertex_layout_decode*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_decode(args)

template bgfx_vertex_layout_has*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_has(args)

template bgfx_vertex_layout_skip*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_skip(args)

template bgfx_vertex_layout_end*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_end(args)

template bgfx_vertex_layout_get_offset*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_get_offset(args)

template bgfx_vertex_layout_get_stride*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_get_stride(args)

template bgfx_vertex_layout_get_size*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_layout_get_size(args)

template bgfx_vertex_pack*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_pack(args)

template bgfx_vertex_unpack*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_unpack(args)

template bgfx_vertex_convert*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.vertex_convert(args)

template bgfx_topology_convert_call*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.topology_convert(args)

template bgfx_topology_sort_tri_list*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.topology_sort_tri_list(args)

template bgfx_get_supported_renderers*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_supported_renderers(args)

template bgfx_get_renderer_name*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_renderer_name(args)

template bgfx_init_ctor*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.init_ctor(args)

template bgfx_init*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.init(args)

template bgfx_shutdown*(_: type BGFX): untyped =
  BGFX.shutdown()

template bgfx_reset*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.reset(args)

template bgfx_frame*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.frame(args)

template bgfx_get_renderer_type*(_: type BGFX): untyped =
  BGFX.get_renderer_type()

template bgfx_get_caps*(_: type BGFX): untyped =
  BGFX.get_caps()

template bgfx_get_stats*(_: type BGFX): untyped =
  BGFX.get_stats()

template bgfx_alloc*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.alloc(args)

template bgfx_copy*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.copy(args)

template bgfx_make_ref*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.make_ref(args)

template bgfx_make_ref_release*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.make_ref_release(args)

template bgfx_set_debug*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_debug(args)

template bgfx_dbg_text_clear*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.dbg_text_clear(args)

template bgfx_dbg_text_printf*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.dbg_text_printf(args)

template bgfx_dbg_text_vprintf*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.dbg_text_vprintf(args)

template bgfx_dbg_text_image*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.dbg_text_image(args)

template bgfx_create_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_index_buffer(args)

template bgfx_set_index_buffer_name*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_index_buffer_name(args)

template bgfx_destroy_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_index_buffer(args)

template bgfx_create_vertex_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_vertex_layout(args)

template bgfx_destroy_vertex_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_vertex_layout(args)

template bgfx_create_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_vertex_buffer(args)

template bgfx_set_vertex_buffer_name*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_vertex_buffer_name(args)

template bgfx_destroy_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_vertex_buffer(args)

template bgfx_create_dynamic_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_dynamic_index_buffer(args)

template bgfx_create_dynamic_index_buffer_mem*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_dynamic_index_buffer_mem(args)

template bgfx_update_dynamic_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.update_dynamic_index_buffer(args)

template bgfx_destroy_dynamic_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_dynamic_index_buffer(args)

template bgfx_create_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_dynamic_vertex_buffer(args)

template bgfx_create_dynamic_vertex_buffer_mem*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_dynamic_vertex_buffer_mem(args)

template bgfx_update_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.update_dynamic_vertex_buffer(args)

template bgfx_destroy_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_dynamic_vertex_buffer(args)

template bgfx_get_avail_transient_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_avail_transient_index_buffer(args)

template bgfx_get_avail_transient_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_avail_transient_vertex_buffer(args)

template bgfx_get_avail_instance_data_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_avail_instance_data_buffer(args)

template bgfx_alloc_transient_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.alloc_transient_index_buffer(args)

template bgfx_alloc_transient_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.alloc_transient_vertex_buffer(args)

template bgfx_alloc_transient_buffers*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.alloc_transient_buffers(args)

template bgfx_alloc_instance_data_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.alloc_instance_data_buffer(args)

template bgfx_create_indirect_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_indirect_buffer(args)

template bgfx_destroy_indirect_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_indirect_buffer(args)

template bgfx_create_shader*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_shader(args)

template bgfx_get_shader_uniforms*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_shader_uniforms(args)

template bgfx_set_shader_name*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_shader_name(args)

template bgfx_destroy_shader*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_shader(args)

template bgfx_create_program*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_program(args)

template bgfx_create_compute_program*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_compute_program(args)

template bgfx_destroy_program*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_program(args)

template bgfx_is_texture_valid*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.is_texture_valid(args)

template bgfx_is_video_codec_valid*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.is_video_codec_valid(args)

template bgfx_is_frame_buffer_valid*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.is_frame_buffer_valid(args)

template bgfx_calc_texture_size*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.calc_texture_size(args)

template bgfx_create_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_texture(args)

template bgfx_create_texture_2d*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_texture_2d(args)

template bgfx_create_texture_2d_scaled*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_texture_2d_scaled(args)

template bgfx_create_texture_3d*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_texture_3d(args)

template bgfx_create_texture_cube*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_texture_cube(args)

template bgfx_update_texture_2d*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.update_texture_2d(args)

template bgfx_update_texture_3d*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.update_texture_3d(args)

template bgfx_update_texture_cube*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.update_texture_cube(args)

template bgfx_clear_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.clear_texture(args)

template bgfx_read_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.read_texture(args)

template bgfx_set_texture_name*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_texture_name(args)

template bgfx_get_direct_access_ptr*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_direct_access_ptr(args)

template bgfx_destroy_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_texture(args)

template bgfx_create_frame_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_frame_buffer(args)

template bgfx_create_frame_buffer_scaled*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_frame_buffer_scaled(args)

template bgfx_create_frame_buffer_from_handles*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_frame_buffer_from_handles(args)

template bgfx_create_frame_buffer_from_attachment*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_frame_buffer_from_attachment(args)

template bgfx_create_frame_buffer_from_nwh*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_frame_buffer_from_nwh(args)

template bgfx_set_frame_buffer_name*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_frame_buffer_name(args)

template bgfx_get_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_texture(args)

template bgfx_destroy_frame_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_frame_buffer(args)

template bgfx_create_uniform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_uniform(args)

template bgfx_create_uniform_with_freq*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.create_uniform_with_freq(args)

template bgfx_get_uniform_info*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_uniform_info(args)

template bgfx_destroy_uniform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_uniform(args)

template bgfx_create_occlusion_query*(_: type BGFX): untyped =
  BGFX.create_occlusion_query()

template bgfx_get_result*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_result(args)

template bgfx_destroy_occlusion_query*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.destroy_occlusion_query(args)

template bgfx_set_palette_color*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_palette_color(args)

template bgfx_set_palette_color_rgba32f*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_palette_color_rgba32f(args)

template bgfx_set_palette_color_rgba8*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_palette_color_rgba8(args)

template bgfx_set_view_name*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_name(args)

template bgfx_set_view_rect*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_rect(args)

template bgfx_set_view_rect_ratio*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_rect_ratio(args)

template bgfx_set_view_scissor*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_scissor(args)

template bgfx_set_view_clear*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_clear(args)

template bgfx_set_view_clear_mrt*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_clear_mrt(args)

template bgfx_set_view_mode*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_mode(args)

template bgfx_set_view_frame_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_frame_buffer(args)

template bgfx_set_view_transform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_transform(args)

template bgfx_set_view_order*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_order(args)

template bgfx_set_view_shading_rate*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_shading_rate(args)

template bgfx_reset_view*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.reset_view(args)

template bgfx_encoder_begin*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_begin(args)

template bgfx_encoder_end*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_end(args)

template bgfx_encoder_set_marker*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_marker(args)

template bgfx_encoder_set_state*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_state(args)

template bgfx_encoder_set_condition*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_condition(args)

template bgfx_encoder_set_stencil*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_stencil(args)

template bgfx_encoder_set_scissor*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_scissor(args)

template bgfx_encoder_set_scissor_cached*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_scissor_cached(args)

template bgfx_encoder_set_transform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_transform(args)

template bgfx_encoder_set_transform_cached*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_transform_cached(args)

template bgfx_encoder_alloc_transform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_alloc_transform(args)

template bgfx_encoder_set_uniform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_uniform(args)

template bgfx_set_view_uniform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_view_uniform(args)

template bgfx_set_frame_uniform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_frame_uniform(args)

template bgfx_encoder_set_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_index_buffer(args)

template bgfx_encoder_set_dynamic_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_dynamic_index_buffer(args)

template bgfx_encoder_set_transient_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_transient_index_buffer(args)

template bgfx_encoder_set_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_vertex_buffer(args)

template bgfx_encoder_set_vertex_buffer_with_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_vertex_buffer_with_layout(args)

template bgfx_encoder_set_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_dynamic_vertex_buffer(args)

template bgfx_encoder_set_dynamic_vertex_buffer_with_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_dynamic_vertex_buffer_with_layout(args)

template bgfx_encoder_set_transient_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_transient_vertex_buffer(args)

template bgfx_encoder_set_transient_vertex_buffer_with_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_transient_vertex_buffer_with_layout(args)

template bgfx_encoder_set_vertex_count*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_vertex_count(args)

template bgfx_encoder_set_instance_data_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_instance_data_buffer(args)

template bgfx_encoder_set_instance_data_from_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_instance_data_from_vertex_buffer(args)

template bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_instance_data_from_dynamic_vertex_buffer(args)

template bgfx_encoder_set_instance_count*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_instance_count(args)

template bgfx_encoder_set_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_texture(args)

template bgfx_encoder_set_texture_view*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_texture_view(args)

template bgfx_encoder_touch*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_touch(args)

template bgfx_encoder_submit*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_submit(args)

template bgfx_encoder_submit_occlusion_query*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_submit_occlusion_query(args)

template bgfx_encoder_submit_indirect*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_submit_indirect(args)

template bgfx_encoder_submit_indirect_count*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_submit_indirect_count(args)

template bgfx_encoder_set_compute_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_compute_index_buffer(args)

template bgfx_encoder_set_compute_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_compute_vertex_buffer(args)

template bgfx_encoder_set_compute_dynamic_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_compute_dynamic_index_buffer(args)

template bgfx_encoder_set_compute_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_compute_dynamic_vertex_buffer(args)

template bgfx_encoder_set_compute_indirect_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_compute_indirect_buffer(args)

template bgfx_encoder_set_image*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_image(args)

template bgfx_encoder_set_image_view*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_set_image_view(args)

template bgfx_encoder_dispatch*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_dispatch(args)

template bgfx_encoder_dispatch_indirect*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_dispatch_indirect(args)

template bgfx_encoder_discard*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_discard(args)

template bgfx_encoder_blit*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.encoder_blit(args)

template bgfx_request_screen_shot*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.request_screen_shot(args)

template bgfx_render_frame_call*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.render_frame(args)

template bgfx_set_platform_data*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_platform_data(args)

template bgfx_get_internal_data*(_: type BGFX): untyped =
  BGFX.get_internal_data()

template bgfx_override_internal_texture_ptr*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.override_internal_texture_ptr(args)

template bgfx_override_internal_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.override_internal_texture(args)

template bgfx_set_marker*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_marker(args)

template bgfx_set_state*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_state(args)

template bgfx_set_condition*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_condition(args)

template bgfx_set_stencil*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_stencil(args)

template bgfx_set_scissor*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_scissor(args)

template bgfx_set_scissor_cached*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_scissor_cached(args)

template bgfx_set_transform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_transform(args)

template bgfx_set_transform_cached*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_transform_cached(args)

template bgfx_alloc_transform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.alloc_transform(args)

template bgfx_set_uniform*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_uniform(args)

template bgfx_set_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_index_buffer(args)

template bgfx_set_dynamic_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_dynamic_index_buffer(args)

template bgfx_set_transient_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_transient_index_buffer(args)

template bgfx_set_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_vertex_buffer(args)

template bgfx_set_vertex_buffer_with_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_vertex_buffer_with_layout(args)

template bgfx_set_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_dynamic_vertex_buffer(args)

template bgfx_set_dynamic_vertex_buffer_with_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_dynamic_vertex_buffer_with_layout(args)

template bgfx_set_transient_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_transient_vertex_buffer(args)

template bgfx_set_transient_vertex_buffer_with_layout*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_transient_vertex_buffer_with_layout(args)

template bgfx_set_vertex_count*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_vertex_count(args)

template bgfx_set_instance_data_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_instance_data_buffer(args)

template bgfx_set_instance_data_from_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_instance_data_from_vertex_buffer(args)

template bgfx_set_instance_data_from_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_instance_data_from_dynamic_vertex_buffer(args)

template bgfx_set_instance_count*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_instance_count(args)

template bgfx_set_texture*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_texture(args)

template bgfx_set_texture_view*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_texture_view(args)

template bgfx_touch*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.touch(args)

template bgfx_submit*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.submit(args)

template bgfx_submit_occlusion_query*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.submit_occlusion_query(args)

template bgfx_submit_indirect*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.submit_indirect(args)

template bgfx_submit_indirect_count*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.submit_indirect_count(args)

template bgfx_set_compute_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_compute_index_buffer(args)

template bgfx_set_compute_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_compute_vertex_buffer(args)

template bgfx_set_compute_dynamic_index_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_compute_dynamic_index_buffer(args)

template bgfx_set_compute_dynamic_vertex_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_compute_dynamic_vertex_buffer(args)

template bgfx_set_compute_indirect_buffer*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_compute_indirect_buffer(args)

template bgfx_set_image*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_image(args)

template bgfx_set_image_view*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.set_image_view(args)

template bgfx_dispatch*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.dispatch(args)

template bgfx_dispatch_indirect*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.dispatch_indirect(args)

template bgfx_discard*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.`discard`(args)

template bgfx_blit*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.blit(args)

template bgfx_get_interface*(_: type BGFX; args: varargs[untyped]): untyped =
  BGFX.get_interface(args)
