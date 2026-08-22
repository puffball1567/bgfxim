# Contributing to bgfxim

bgfxim is a thin binding to a pinned bgfx C99 API. Changes should preserve the
upstream ABI and keep generated files reproducible.

## Project Scope

bgfxim exists to provide a faithful, low-level Nim representation of bgfx's
generated C99 API. The upstream header, ABI, ownership model, threading rules,
and versioned behavior remain authoritative. Convenience additions are kept to
small, lossless Nim adaptations such as the `BGFX` namespace, typed handles,
and direct constant helpers.

The following work belongs in this repository:

- tracking a new upstream bgfx C99 API revision;
- correcting generated declarations, constants, layouts, or calling
  conventions;
- improving generators and reproducibility checks;
- adding ABI, FFI, renderer, platform, and regression coverage;
- improving portability, documentation, licensing, and focused integration
  demos;
- fixing behavior needed to expose the pinned upstream API accurately.

The following work should normally be implemented in a separate package that
depends on bgfxim:

- high-level rendering or scene APIs;
- automatic resource-lifetime or ownership systems;
- renderer selection, window-framework integration, or native dependency
  builds for applications;
- shader, material, asset, frame-graph, ECS, or game-engine abstractions;
- convenience APIs that hide, reinterpret, or replace upstream bgfx behavior.

Applications and libraries are encouraged to wrap bgfxim at the abstraction
level they need. Keeping those policies outside this package lets different
Nim APIs evolve without compromising the binding's fidelity or forcing one
rendering model on all users.

In practice, most ongoing work is expected to be upstream-version tracking,
test and platform coverage, generator maintenance, bug fixes, and
documentation. Proposals for higher-level APIs are still useful, but will
usually be directed to a separate companion package.

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
python3 tools/generate_abi_test.py bgfx.nim tests/test_abi.nim
python3 tools/generate_value_test.py \
  bgfx.nim bgfx/defines.nim tests/test_values.nim
tests/run_validation.sh <path-to-bgfx> <path-to-bx>
```

The runner compiles and executes the API, exhaustive layout/value, normal and
error FFI, generator rejection, and all-call signature checks with the matching
headers. CI repeats it across the supported OS, Nim, architecture, compiler,
memory-management, and optimization matrix. Changes affecting ownership,
resources, encoders, validation, or platform data should also run the real
NOOP or SDL3 demos as appropriate.

Do not test a documented assertion, fatal condition, or undefined precondition
against the real bgfx library. Use the C stub for those ABI paths. Real-library
negative tests should be limited to APIs documented to return a validation or
negotiation failure without terminating the process.

## Ground Rules

- Preserve bgfx's exact integer widths, calling conventions, object layouts,
  ownership rules, and API-thread requirements.
- Prefer a direct, mechanically verifiable mapping over a more opinionated Nim
  API when the two goals conflict.
- Keep the low-level binding usable without SDL or another window library.
- Do not silently select or build a renderer backend for consuming projects.
- Keep examples focused on validating or explaining the binding rather than
  growing them into an application framework.
- Keep examples portable and use placeholders instead of machine-specific
  paths.
- Record native dependency versions and licenses when they change.

## Contribution License

Unless stated otherwise, contributions intentionally submitted to bgfxim are
provided under the [BSD 2-Clause License](LICENSE). Submit only work that you
have the right to license under those terms.
