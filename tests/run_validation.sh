#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause

set -eu

if [ "$#" -lt 2 ]; then
  echo "usage: tests/run_validation.sh <bgfx-dir> <bx-dir> [nim-options...]" >&2
  exit 2
fi

bgfx_dir=$1
bx_dir=$2
shift 2

for required_file in \
  "$bgfx_dir/include/bgfx/c99/bgfx.h" \
  "$bgfx_dir/include/bgfx/defines.h" \
  "$bx_dir/include/bx/platform.h"
do
  if [ ! -f "$required_file" ]; then
    echo "missing required header: $required_file" >&2
    exit 2
  fi
done

nim_compiler=${NIM:-nim}
python=${PYTHON:-python3}
build_dir=$(mktemp -d ".bgfxim-validation.XXXXXX")
trap 'rm -rf -- "$build_dir"' EXIT HUP INT TERM

run_test() {
  test_name=$1
  shift
  "$nim_compiler" c -r --path:. \
    --nimcache:"$build_dir/nim-$test_name" \
    -o:"$build_dir/$test_name" \
    --passC:"-I$bgfx_dir/include" \
    --passC:"-I$bx_dir/include" \
    "$@" "tests/$test_name.nim"
}

echo "backend=c"
run_test test_api "$@"
run_test test_abi "$@"
run_test test_values "$@"
run_test test_runtime "$@"
run_test test_errors "$@"

"$python" tests/test_generators.py

signature_test="$build_dir/all_signatures.nim"
"$python" tools/generate_signature_test.py \
  "$bgfx_dir/include/bgfx/c99/bgfx.h" "$signature_test"
"$nim_compiler" c --noLinking:on --path:. \
  --nimcache:"$build_dir/nim-all-signatures" \
  --passC:"-I$bgfx_dir/include" \
  --passC:"-I$bx_dir/include" \
  "$@" "$signature_test"

echo "validation suite passed"
