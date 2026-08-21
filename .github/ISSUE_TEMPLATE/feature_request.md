---
name: Feature request
about: Propose a binding, generator, test, or integration improvement
title: ""
labels: enhancement
assignees: ""
---

## Use Case

Describe the application or binding workflow this enables.

## Proposed Boundary

Explain whether this belongs in the low-level binding, generation tools,
verification suite, or a separate higher-level package.

bgfxim preserves a direct mapping to the upstream C99 API. High-level
rendering, resource-management, window, shader, asset, and engine abstractions
will normally belong in a separate package built on bgfxim.

## API Shape

Show a small Nim example if possible.

## Compatibility

Describe bgfx revision, ABI, ownership, renderer, platform, and packaging impact.
