#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
# bgfx is Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause.
# See ../LICENSE and ../THIRD_PARTY_NOTICES.md.

set -eu

if [ "$#" -ne 3 ]; then
  echo "usage: examples/run_noop_demos.sh <bgfx-dir> <bx-dir> <bimg-dir>" >&2
  exit 2
fi

bgfx_dir=$1
bx_dir=$2
bimg_dir=$3

for required_file in \
  "$bgfx_dir/src/amalgamated.cpp" \
  "$bx_dir/src/amalgamated.cpp" \
  "$bimg_dir/src/image.cpp" \
  "$bimg_dir/3rdparty/astc-encoder/include/astcenc.h"
do
  if [ ! -f "$required_file" ]; then
    echo "missing required source: $required_file" >&2
    exit 2
  fi
done

build_dir=$(mktemp -d "${TMPDIR:-/tmp}/bgfxim-noop.XXXXXX")
trap 'rm -rf -- "$build_dir"' EXIT HUP INT TERM

cxx=${CXX:-c++}
archiver=${AR:-ar}
nim_compiler=${NIM:-nim}
simd_flag=
case $(uname -m) in
  x86_64|amd64) simd_flag=-msse4.1 ;;
esac

dynamic_loader_lib=
darwin_link=false
set --
case $(uname -s) in
  Darwin)
    cxx_runtime_lib=-lc++
    darwin_link=true
    set -- "-I$bx_dir/include/compat/osx"
    ;;
  Linux)
    cxx_runtime_lib=-lstdc++
    dynamic_loader_lib=-ldl
    ;;
  *)
    echo "unsupported host for this helper: $(uname -s)" >&2
    exit 2
    ;;
esac

echo "bgfxim: BSD-2-Clause"
echo "bgfx/bx/bimg: Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause"
echo "building a temporary NOOP-only bgfx library..."

"$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
  -DBX_CONFIG_DEBUG=0 \
  "$@" \
  -I"$bx_dir/include" -I"$bx_dir/3rdparty" \
  -c "$bx_dir/src/amalgamated.cpp" -o "$build_dir/bx.o"

# Defining one backend option selects the explicit configuration branch; all
# unspecified GPU backends become disabled while bgfx's NOOP backend remains.
"$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
  -DBX_CONFIG_DEBUG=0 -DBGFX_CONFIG_RENDERER_VULKAN=0 \
  "$@" \
  -I"$bgfx_dir/include" -I"$bgfx_dir/src" -I"$bgfx_dir/3rdparty" \
  -I"$bx_dir/include" -I"$bx_dir/3rdparty" -I"$bimg_dir/include" \
  -c "$bgfx_dir/src/amalgamated.cpp" -o "$build_dir/bgfx.o"

"$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
  -DBX_CONFIG_DEBUG=0 -DASTCENC_F16C=0 -DASTCENC_NEON=0 \
  "$@" \
  -I"$bimg_dir/include" -I"$bimg_dir/3rdparty/astc-encoder/include" \
  -I"$bx_dir/include" -I"$bx_dir/3rdparty" \
  -c "$bimg_dir/src/image.cpp" -o "$build_dir/bimg.o"

for astc_source in "$bimg_dir"/3rdparty/astc-encoder/source/*.cpp
do
  astc_name=${astc_source##*/}
  "$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
    -DASTCENC_F16C=0 -DASTCENC_NEON=0 \
    "$@" \
    -I"$bimg_dir/3rdparty/astc-encoder/include" \
    -I"$bimg_dir/3rdparty/astc-encoder/source" \
    -c "$astc_source" -o "$build_dir/${astc_name%.cpp}.o"
done

"$archiver" rcs "$build_dir/libbimg.a" "$build_dir/bimg.o" \
  "$build_dir"/astcenc_*.o

for demo in noop_basic noop_resources noop_validation
do
  set -- "--passL:$cxx_runtime_lib" --passL:-pthread --passL:-lm
  if [ -n "$dynamic_loader_lib" ]; then
    set -- "$@" "--passL:$dynamic_loader_lib"
  fi
  if [ "$darwin_link" = true ]; then
    set -- "$@" --passL:-framework --passL:Foundation \
      --passL:-framework --passL:CoreFoundation --passL:-lobjc
  fi
  "$nim_compiler" c -r --path:. \
    --nimcache:"$build_dir/nim-$demo" -o:"$build_dir/$demo" \
    --passC:"-I$bgfx_dir/include" --passC:"-I$bx_dir/include" \
    --passL:"$build_dir/bgfx.o" --passL:"$build_dir/libbimg.a" \
    --passL:"$build_dir/bx.o" "$@" "examples/$demo.nim"
done
