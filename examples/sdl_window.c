/* SPDX-License-Identifier: BSD-2-Clause */
/* SDL 3 is used under the zlib License; see ../THIRD_PARTY_NOTICES.md. */

#include <SDL3/SDL.h>
#include <stdint.h>

void* bgfxim_sdl_create_window(const char* title, int width, int height)
{
    if (!SDL_Init(SDL_INIT_VIDEO))
    {
        return NULL;
    }

    return SDL_CreateWindow(title, width, height, SDL_WINDOW_RESIZABLE);
}

const char* bgfxim_sdl_error(void)
{
    return SDL_GetError();
}

int bgfxim_sdl_get_platform_data(void* window, void** ndt, void** nwh,
    int* native_window_type)
{
    SDL_PropertiesID properties = SDL_GetWindowProperties((SDL_Window*)window);
    if (0 == properties)
    {
        return 0;
    }

    void* display = SDL_GetPointerProperty(properties,
        SDL_PROP_WINDOW_X11_DISPLAY_POINTER, NULL);
    Sint64 x11_window = SDL_GetNumberProperty(properties,
        SDL_PROP_WINDOW_X11_WINDOW_NUMBER, 0);
    if (NULL != display && 0 != x11_window)
    {
        *ndt = display;
        *nwh = (void*)(uintptr_t)x11_window;
        *native_window_type = 0;
        return 1;
    }

    display = SDL_GetPointerProperty(properties,
        SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER, NULL);
    void* surface = SDL_GetPointerProperty(properties,
        SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER, NULL);
    if (NULL != display && NULL != surface)
    {
        *ndt = display;
        *nwh = surface;
        *native_window_type = 1;
        return 1;
    }

    SDL_SetError("the SDL 3 video backend is not X11 or Wayland");
    return 0;
}

int bgfxim_sdl_poll_window(void* window, int* width, int* height)
{
    SDL_Event event;
    while (SDL_PollEvent(&event))
    {
        if (SDL_EVENT_QUIT == event.type)
        {
            return 0;
        }
        if (SDL_EVENT_KEY_DOWN == event.type && SDLK_ESCAPE == event.key.key)
        {
            return 0;
        }
    }

    return SDL_GetWindowSize((SDL_Window*)window, width, height) ? 1 : 0;
}

void bgfxim_sdl_delay(unsigned int milliseconds)
{
    SDL_Delay(milliseconds);
}

void bgfxim_sdl_destroy_window(void* window)
{
    if (NULL != window)
    {
        SDL_DestroyWindow((SDL_Window*)window);
    }
    SDL_Quit();
}
