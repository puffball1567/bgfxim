/* SPDX-License-Identifier: BSD-2-Clause */
#include <bgfx/c99/bgfx.h>
#include <stdint.h>

static uint32_t s_calls;
static const void* s_uniform_ref;

/* Independent C-side expectations detect argument order, width and pointer
 * errors at the Nim/C boundary, including both encoder and global entrypoints. */
#define CHECK_CALL(bit, condition) do { if (condition) s_calls |= UINT32_C(1) << (bit); } while (0)
#define ENCODER_OK ((uintptr_t)encoder == UINT32_C(0x4560))
#define DEPTH_OK (constant == -7 && slope == 1.25f && clamp == -1.0f)
#define UNIFORM_OK (handle.idx == 17 && value != NULL && num == 2)

void bgfx_set_view_rect(bgfx_view_id_t id, int16_t x, int16_t y,
    uint16_t width, uint16_t height, float min_depth, float max_depth)
{
    CHECK_CALL(0, id == UINT16_MAX && x == -2 && y == -3
        && width == 640 && height == 480 && min_depth == 0.25f && max_depth == 0.75f);
}

void bgfx_set_view_depth_bias(bgfx_view_id_t id, int32_t constant, float slope, float clamp)
{ CHECK_CALL(1, id == UINT16_MAX && DEPTH_OK); }

void bgfx_set_view_sample_mask(bgfx_view_id_t id, uint32_t mask)
{ CHECK_CALL(2, id == UINT16_MAX && mask == UINT32_C(0x80000001)); }

void bgfx_set_sample_mask(uint32_t mask)
{ CHECK_CALL(3, mask == UINT32_MAX); }

void bgfx_encoder_set_sample_mask(bgfx_encoder_t* encoder, uint32_t mask)
{ CHECK_CALL(4, ENCODER_OK && mask == UINT32_C(0x80000001)); }

uint16_t bgfx_set_depth_control(int32_t constant, float slope, float clamp, bool depth_clamp)
{
    CHECK_CALL(5, DEPTH_OK && depth_clamp);
    return UINT16_C(0xabcd);
}

uint16_t bgfx_encoder_set_depth_control(bgfx_encoder_t* encoder,
    int32_t constant, float slope, float clamp, bool depth_clamp)
{
    CHECK_CALL(6, ENCODER_OK && DEPTH_OK && !depth_clamp);
    return UINT16_C(0xdef0);
}

void bgfx_set_depth_control_cached(uint16_t cache)
{ CHECK_CALL(7, cache == UINT16_C(0xabcd)); }

void bgfx_encoder_set_depth_control_cached(bgfx_encoder_t* encoder, uint16_t cache)
{ CHECK_CALL(8, ENCODER_OK && cache == UINT16_C(0xdef0)); }

void bgfx_set_uniform_ref(bgfx_uniform_handle_t handle, const void* value, uint16_t num)
{
    CHECK_CALL(9, UNIFORM_OK);
    s_uniform_ref = value;
}

void bgfx_encoder_set_uniform_ref(bgfx_encoder_t* encoder,
    bgfx_uniform_handle_t handle, const void* value, uint16_t num)
{
    CHECK_CALL(10, ENCODER_OK && UNIFORM_OK && value == s_uniform_ref);
}

#define TEXTURE_PARAMS uint8_t stage, bgfx_uniform_handle_t sampler, \
    bgfx_texture_handle_t handle, uint16_t first_layer, uint16_t num_layers, \
    uint8_t first_mip, uint8_t num_mips, uint32_t flags, uint8_t lod_min, uint8_t lod_max
#define TEXTURE_OK (stage == UINT8_MAX && sampler.idx == 17 && handle.idx == 23 \
    && first_layer == 257 && num_layers == 513 && first_mip == 3 && num_mips == 5 \
    && flags == UINT32_MAX && lod_min == 7 && lod_max == UINT8_MAX)

void bgfx_set_texture_view(TEXTURE_PARAMS)
{ CHECK_CALL(11, TEXTURE_OK); }

void bgfx_encoder_set_texture_view(bgfx_encoder_t* encoder, TEXTURE_PARAMS)
{ CHECK_CALL(12, ENCODER_OK && TEXTURE_OK); }

#define COMPUTE_OK (stage == UINT8_MAX && handle.idx == UINT16_MAX - 1 \
    && access == BGFX_ACCESS_READWRITE && offset == UINT32_C(0xffffff00) && size == UINT32_MAX)
#define COMPUTE_STUB(name, type, bit) \
    void bgfx_set_compute_##name(uint8_t stage, type handle, bgfx_access_t access, uint32_t offset, uint32_t size) \
    { CHECK_CALL(bit, COMPUTE_OK); } \
    void bgfx_encoder_set_compute_##name(bgfx_encoder_t* encoder, uint8_t stage, type handle, bgfx_access_t access, uint32_t offset, uint32_t size) \
    { CHECK_CALL((bit) + 1, ENCODER_OK && COMPUTE_OK); }

COMPUTE_STUB(index_buffer, bgfx_index_buffer_handle_t, 13)
COMPUTE_STUB(vertex_buffer, bgfx_vertex_buffer_handle_t, 15)
COMPUTE_STUB(dynamic_index_buffer, bgfx_dynamic_index_buffer_handle_t, 17)
COMPUTE_STUB(dynamic_vertex_buffer, bgfx_dynamic_vertex_buffer_handle_t, 19)

void bgfx_attachment_init(bgfx_attachment_t* attachment, bgfx_texture_handle_t handle,
    bgfx_access_t access, uint16_t layer, uint16_t num_layers, uint16_t mip, uint8_t flags)
{
    attachment->handle = handle;
    attachment->access = access;
    attachment->layer = layer;
    attachment->numLayers = num_layers;
    attachment->mip = mip;
    attachment->flags = flags;
    CHECK_CALL(21, handle.idx == 23 && access == BGFX_ACCESS_READ
        && layer == 257 && num_layers == 513 && mip == 7
        && flags == (BGFX_ATTACHMENT_READ_ONLY_DEPTH | BGFX_ATTACHMENT_SRGB));
}

bool bgfxim_test_api166_validated(void)
{ return s_calls == ((UINT32_C(1) << 22) - 1); }

const void* bgfxim_test_uniform_ref(void)
{ return s_uniform_ref; }

bgfx_interface_vtbl_t* bgfxim_test_api166_interface(void)
{
    static bgfx_interface_vtbl_t vtable;
    vtable.set_uniform_ref = bgfx_set_uniform_ref;
    vtable.encoder_set_depth_control = bgfx_encoder_set_depth_control;
    return &vtable;
}
