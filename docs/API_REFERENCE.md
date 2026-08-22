# API Reference

The public bgfx calls in `bgfx.nim` carry Nim documentation comments. An
editor using Nim's language server can show each call's purpose, parameters,
parameter directions, return value, remarks, threading constraints, ownership
requirements, and warnings directly in hover and completion information.

The reference covers all 208 public C99 calls in the pinned bgfx revision.
Names in the prose are adapted to the Nim surface where an exact counterpart
exists, for example `bgfx::createTexture2D` becomes `BGFX.create_texture_2d`
and `RendererType::Enum` becomes `bgfx_renderer_type_t`.

## Browse in an editor

Import the module and hover a typed namespace call:

```nim
import bgfx

var init: bgfx_init_t
BGFX.initCtor(addr init)
discard BGFX.init(addr init)
```

The canonical documented API uses `BGFX.<name>`. Compatibility aliases with
the original `bgfx_` prefix remain available, but editors may direct their
documentation to the canonical declaration.

## Build HTML documentation

From the repository root, run:

```sh
tools/build_api_docs.sh
```

The command writes `build/api/index.html`. To choose another directory, pass it
as the only argument:

```sh
tools/build_api_docs.sh /tmp/bgfxim-api
```

The build needs Nim 2.0 or newer but does not need compiled bgfx libraries.

The published reference uses a responsive left sidebar, full API search,
light and dark themes, direct anchors, and compact parameter tables. It is
deployed from the `devel` branch because that is bgfxim's default branch and
the source of the next upstream-tracking update.

## Documentation source

Function descriptions are synchronized from the C99 API comments at the
bgfx revision recorded in the README and third-party notices. The binding
update tool validates that every public call and each non-implicit parameter
has documentation. `bgfx_get_interface` is the only upstream declaration with
an empty documentation marker, so bgfxim supplies its API-version behavior
from the corresponding upstream implementation.

The bgfx-derived documentation remains covered by the upstream notice in
[THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md).
