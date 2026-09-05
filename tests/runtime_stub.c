/* SPDX-License-Identifier: BSD-2-Clause */

#include <bgfx/c99/bgfx.h>

#include <stdarg.h>
#include <stdint.h>
#include <string.h>

static bool s_init_validated;
static bool s_shutdown;
static bool s_varargs_validated;
static uint32_t s_debug_flags;
static bgfx_frame_buffer_handle_t s_debug_handle;
static uint8_t s_debug_scale;
static uint8_t s_frame_flags;
static uint8_t s_memory_data[64];
static bgfx_memory_t s_memory;
static bgfx_release_fn_t s_release_fn;
static void* s_release_ptr;
static void* s_release_user_data;

void bgfx_texture_region_init(bgfx_texture_region_t* region,
    bgfx_texture_handle_t handle, uint16_t x, uint16_t y, uint16_t width,
    uint16_t height)
{
    memset(region, 0, sizeof(*region));
    region->handle = handle;
    region->x = x;
    region->y = y;
    region->width = width;
    region->height = height;
}

void bgfx_buffer_region_init_buffer(bgfx_buffer_region_t* region,
    bgfx_buffer_handle_t handle, uint32_t offset, uint32_t size)
{
    memset(region, 0, sizeof(*region));
    region->handle = handle;
    region->offset = offset;
    region->size = size;
}

void bgfx_init_ctor(bgfx_init_t* init)
{
    memset(init, 0, sizeof(*init));
    init->type = BGFX_RENDERER_TYPE_NOOP;
    init->vendorId = UINT16_C(0x1234);
    init->swapChain.width = UINT32_C(640);
    init->swapChain.height = UINT32_C(480);
}

bool bgfx_init(const bgfx_init_t* init)
{
    s_init_validated = NULL != init
        && BGFX_RENDERER_TYPE_NOOP == init->type
        && UINT16_C(0x1234) == init->vendorId
        && UINT32_C(640) == init->swapChain.width
        && UINT32_C(480) == init->swapChain.height;
    return s_init_validated;
}

void bgfx_shutdown(void)
{
    s_shutdown = true;
}

void bgfx_set_debug(uint32_t debug, bgfx_frame_buffer_handle_t handle,
    uint8_t scale)
{
    s_debug_flags = debug;
    s_debug_handle = handle;
    s_debug_scale = scale;
}

void bgfx_dbg_text_printf(uint16_t x, uint16_t y, uint8_t attr,
                          const char* format, ...)
{
    va_list args;
    va_start(args, format);
    const int value = va_arg(args, int);
    va_end(args);

    s_varargs_validated = UINT16_C(7) == x
        && UINT16_C(9) == y
        && UINT8_C(0x1f) == attr
        && 0 == strcmp("%d", format)
        && 42 == value;
}

bgfx_vertex_layout_t* bgfx_vertex_layout_begin(
    bgfx_vertex_layout_t* layout,
    bgfx_renderer_type_t renderer_type)
{
    memset(layout, 0, sizeof(*layout));
    layout->hash = UINT32_C(0xabcdef01);
    layout->stride = BGFX_RENDERER_TYPE_NOOP == renderer_type ? 4 : 0;
    return layout;
}

bgfx_vertex_layout_t* bgfx_vertex_layout_add(
    bgfx_vertex_layout_t* layout,
    bgfx_attrib_t attrib,
    uint8_t num,
    bgfx_attrib_type_t type,
    bool normalized,
    bool as_int)
{
    if (BGFX_ATTRIB_POSITION == attrib
    && 3 == num
    && BGFX_ATTRIB_TYPE_FLOAT == type
    && !normalized
    && !as_int)
    {
        layout->stride = 12;
    }
    return layout;
}

void bgfx_vertex_layout_end(bgfx_vertex_layout_t* layout)
{
    layout->hash ^= UINT32_C(0xffffffff);
}

uint8_t bgfx_get_supported_renderers(uint8_t max, bgfx_renderer_type_t* result)
{
    if (0 != max && NULL != result)
    {
        result[0] = BGFX_RENDERER_TYPE_NOOP;
    }
    return 1;
}

const char* bgfx_get_renderer_name(bgfx_renderer_type_t type)
{
    return BGFX_RENDERER_TYPE_NOOP == type ? "StubRenderer" : "Unknown";
}

bgfx_renderer_type_t bgfx_get_renderer_type(void)
{
    return BGFX_RENDERER_TYPE_NOOP;
}

const bgfx_caps_t* bgfx_get_caps(void)
{
    static bgfx_caps_t caps;
    caps.rendererType = BGFX_RENDERER_TYPE_NOOP;
    caps.vendorId = UINT16_C(0xbeef);
    caps.limits.maxDrawCalls = UINT32_C(321);
    return &caps;
}

const bgfx_memory_t* bgfx_alloc(uint32_t size)
{
    if (0 == size || sizeof(s_memory_data) < size)
    {
        return NULL;
    }

    memset(s_memory_data, 0, sizeof(s_memory_data));
    s_memory.data = s_memory_data;
    s_memory.size = size;
    return &s_memory;
}

const bgfx_memory_t* bgfx_copy(const void* data, uint32_t size)
{
    if (NULL == data || 0 == size || sizeof(s_memory_data) < size)
    {
        return NULL;
    }

    memcpy(s_memory_data, data, size);
    s_memory.data = s_memory_data;
    s_memory.size = size;
    return &s_memory;
}

const bgfx_memory_t* bgfx_make_ref_release(
    const void* data,
    uint32_t size,
    bgfx_release_fn_t release_fn,
    void* user_data)
{
    if (NULL == data || 0 == size || NULL == release_fn)
    {
        return NULL;
    }

    s_memory.data = (uint8_t*)data;
    s_memory.size = size;
    s_release_fn = release_fn;
    s_release_ptr = (void*)data;
    s_release_user_data = user_data;
    return &s_memory;
}

bool bgfx_is_texture_valid(
    uint16_t depth,
    bool cube_map,
    uint16_t num_layers,
    bgfx_texture_format_t format,
    uint64_t flags)
{
    if (BGFX_TEXTURE_FORMAT_COUNT <= format
    ||  0 == num_layers
    ||  (cube_map && 1 < depth)
    ||  (0 != (flags & BGFX_TEXTURE_RT_MASK)
        && 0 != (flags & BGFX_TEXTURE_READ_BACK))
    ||  (0 != (flags & BGFX_TEXTURE_COMPUTE_WRITE)
        && 0 != (flags & BGFX_TEXTURE_READ_BACK)))
    {
        return false;
    }
    return true;
}

bool bgfx_is_video_codec_valid(
    bgfx_video_codec_t codec,
    uint8_t chroma,
    uint8_t bit_depth,
    uint16_t coded_width,
    uint16_t coded_height,
    uint8_t max_dpb_slots,
    uint8_t max_active_references)
{
    return BGFX_VIDEO_CODEC_H264 == codec
        && 0 == chroma
        && 8 == bit_depth
        && 1920 == coded_width
        && 1080 == coded_height
        && 4 == max_dpb_slots
        && max_active_references <= max_dpb_slots;
}

bool bgfx_is_frame_buffer_valid(
    uint8_t num,
    const bgfx_attachment_t* attachment)
{
    return 0 != num
        && NULL != attachment
        && UINT16_MAX != attachment[0].handle.idx;
}

uint32_t bgfx_frame(uint8_t flags)
{
    s_frame_flags = flags;
    return UINT32_C(0x12345678);
}

bgfx_interface_vtbl_t* bgfx_get_interface(uint32_t version)
{
    return BGFX_API_VERSION == version
        ? (bgfx_interface_vtbl_t*)(uintptr_t)0x1230u
        : NULL;
}

bool bgfxim_test_init_validated(void)
{
    return s_init_validated;
}

bool bgfxim_test_shutdown_called(void)
{
    return s_shutdown;
}

bool bgfxim_test_varargs_validated(void)
{
    return s_varargs_validated;
}

uint32_t bgfxim_test_debug_flags(void)
{
    return s_debug_flags;
}

uint16_t bgfxim_test_debug_handle(void)
{
    return s_debug_handle.idx;
}

uint8_t bgfxim_test_debug_scale(void)
{
    return s_debug_scale;
}

uint8_t bgfxim_test_frame_flags(void)
{
    return s_frame_flags;
}

bool bgfxim_test_trigger_release(void)
{
    if (NULL == s_release_fn)
    {
        return false;
    }

    bgfx_release_fn_t release_fn = s_release_fn;
    s_release_fn = NULL;
    release_fn(s_release_ptr, s_release_user_data);
    return true;
}

void* bgfxim_test_call_allocator(
    bgfx_allocator_interface_t* allocator,
    size_t size,
    size_t align)
{
    if (NULL == allocator
    ||  NULL == allocator->vtbl
    ||  NULL == allocator->vtbl->realloc)
    {
        return NULL;
    }

    return allocator->vtbl->realloc(
        allocator, NULL, size, align, "runtime_stub.c", UINT32_C(0xffffffff));
}

bool bgfxim_test_trigger_fatal(bgfx_callback_interface_t* callback)
{
    if (NULL == callback
    ||  NULL == callback->vtbl
    ||  NULL == callback->vtbl->fatal)
    {
        return false;
    }

    callback->vtbl->fatal(
        callback,
        "runtime_stub.c",
        UINT16_C(0xffff),
        BGFX_FATAL_INVALID_SHADER,
        "synthetic fatal path");
    return true;
}
