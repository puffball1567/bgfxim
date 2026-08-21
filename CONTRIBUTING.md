# Contributing to bgfxim

bgfxim is a thin binding to a pinned bgfx C99 API. Changes should preserve the
upstream ABI and keep generated files reproducible.

## Branch and Release Workflow

- Create feature, documentation, and fix branches from `devel`.
- Open ordinary pull requests against `devel`; feature work does not target
  `main` directly.
- Keep `devel` green with the generated-source, ABI, FFI, and real-NOOP checks.
- For a release, merge `devel` into `main` with a merge commit after release
  checks pass. Create version tags from `main` only.
- Use `hotfix/*` only for urgent corrections based on `main`, then apply the
  same correction back to `devel`.
- Repository Rulesets require pull requests for protected branches. A source
  policy accepts pull requests to `main` only from this repository's `devel` or
  `hotfix/*` branches.

## Binding Updates

An upstream revision update must include:

- the pinned revision and API version in documentation and source headers;
- regenerated `bgfx.nim` declarations and `bgfx/defines.nim` constants;
- any required manual struct, enum, callback, or interface-vtable corrections;
- updated compile-time ABI assertions and runtime coverage;
- updated bgfx, bx, and bimg revisions in `THIRD_PARTY_NOTICES.md`;
- a `CHANGELOG.md` entry.

Do not hand-edit generated declaration or constant blocks when the generator can
represent the change. Generator changes and regenerated output belong in the
same commit.

## Verification

Before opening a pull request:

```sh
nimble check
python3 tools/generate_defines.py \
  <path-to-bgfx>/include/bgfx/defines.h bgfx/defines.nim
python3 tools/update_bindings.py \
  <path-to-bgfx>/include/bgfx/c99/bgfx.h bgfx.nim
```

Compile and run `tests/test_api.nim` and `tests/test_runtime.nim` with the
matching bgfx and bx include directories. Generate and C-compile the all-call
signature test. Changes affecting ownership, resources, encoders, or platform
data should also run the real NOOP or SDL3 demos as appropriate.

## Ground Rules

- Preserve bgfx's exact integer widths, calling conventions, object layouts,
  ownership rules, and API-thread requirements.
- Keep the low-level binding usable without SDL or another window library.
- Do not silently select or build a renderer backend for consuming projects.
- Keep examples portable and use placeholders instead of machine-specific
  paths.
- Record native dependency versions and licenses when they change.

## Contribution License

Unless stated otherwise, contributions intentionally submitted to bgfxim are
provided under the [BSD 2-Clause License](LICENSE). Submit only work that you
have the right to license under those terms.
