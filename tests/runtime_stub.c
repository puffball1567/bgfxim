#include <bgfx/c99/bgfx.h>

#include <stdarg.h>
#include <stdint.h>
#include <string.h>

static bool s_init_validated;
static bool s_shutdown;
static bool s_varargs_validated;
static uint32_t s_debug_flags;
static uint8_t s_frame_flags;

void bgfx_init_ctor(bgfx_init_t* init)
{
    memset(init, 0, sizeof(*init));
    init->type = BGFX_RENDERER_TYPE_NOOP;
    init->vendorId = UINT16_C(0x1234);
    init->resolution.width = UINT32_C(640);
    init->resolution.height = UINT32_C(480);
}

bool bgfx_init(const bgfx_init_t* init)
{
    s_init_validated = NULL != init
        && BGFX_RENDERER_TYPE_NOOP == init->type
        && UINT16_C(0x1234) == init->vendorId
        && UINT32_C(640) == init->resolution.width
        && UINT32_C(480) == init->resolution.height;
    return s_init_validated;
}

void bgfx_shutdown(void)
{
    s_shutdown = true;
}

void bgfx_set_debug(uint32_t debug)
{
    s_debug_flags = debug;
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
        return 1;
    }
    return 0;
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

uint8_t bgfxim_test_frame_flags(void)
{
    return s_frame_flags;
}
