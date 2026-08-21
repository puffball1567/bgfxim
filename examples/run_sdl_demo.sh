#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
# bgfx is Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause.
# SDL 3 is used under the zlib License.
# See ../LICENSE and ../THIRD_PARTY_NOTICES.md.

set -eu

if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
  echo "usage: examples/run_sdl_demo.sh <bgfx-dir> <bx-dir> <bimg-dir> [frames]" >&2
  exit 2
fi

bgfx_dir=$1
bx_dir=$2
bimg_dir=$3
demo_frames=${4:-0}

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

if ! pkg-config --exists sdl3; then
  echo "SDL 3 was not found; install its development package for pkg-config" >&2
  exit 2
fi

build_dir=$(mktemp -d "${TMPDIR:-/tmp}/bgfxim-sdl.XXXXXX")
trap 'rm -rf -- "$build_dir"' EXIT HUP INT TERM

cxx=${CXX:-c++}
nim_compiler=${NIM:-nim}
simd_flag=
case $(uname -m) in
  x86_64|amd64) simd_flag=-msse4.1 ;;
esac
sdl_cflags=$(pkg-config --cflags sdl3)
sdl_libs=$(pkg-config --libs sdl3)

echo "bgfxim: BSD-2-Clause"
echo "bgfx/bx/bimg: Copyright 2010-2026 Branimir Karadzic, BSD-2-Clause"
echo "SDL 3: zlib License (see THIRD_PARTY_NOTICES.md)"
echo "building a temporary OpenGL bgfx library..."

"$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
  -DBX_CONFIG_DEBUG=0 \
  -I"$bx_dir/include" -I"$bx_dir/3rdparty" \
  -c "$bx_dir/src/amalgamated.cpp" -o "$build_dir/bx.o"

"$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
  -DBX_CONFIG_DEBUG=0 -DBGFX_CONFIG_RENDERER_OPENGL=43 \
  -I"$bgfx_dir/include" -I"$bgfx_dir/src" -I"$bgfx_dir/3rdparty" \
  -I"$bgfx_dir/3rdparty/khronos" \
  -I"$bx_dir/include" -I"$bx_dir/3rdparty" -I"$bimg_dir/include" \
  -c "$bgfx_dir/src/amalgamated.cpp" -o "$build_dir/bgfx.o"

"$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
  -DBX_CONFIG_DEBUG=0 -DASTCENC_F16C=0 -DASTCENC_NEON=0 \
  -I"$bimg_dir/include" -I"$bimg_dir/3rdparty/astc-encoder/include" \
  -I"$bx_dir/include" -I"$bx_dir/3rdparty" \
  -c "$bimg_dir/src/image.cpp" -o "$build_dir/bimg.o"

for astc_source in "$bimg_dir"/3rdparty/astc-encoder/source/*.cpp
do
  astc_name=${astc_source##*/}
  "$cxx" -std=c++20 -O2 -fPIC -pthread $simd_flag \
    -DASTCENC_F16C=0 -DASTCENC_NEON=0 \
    -I"$bimg_dir/3rdparty/astc-encoder/include" \
    -I"$bimg_dir/3rdparty/astc-encoder/source" \
    -c "$astc_source" -o "$build_dir/${astc_name%.cpp}.o"
done

ar rcs "$build_dir/libbimg.a" "$build_dir/bimg.o" \
  "$build_dir"/astcenc_*.o

"$nim_compiler" c -r --path:. \
  --nimcache:"$build_dir/nim-sdl" -o:"$build_dir/sdl-clear" \
  --passC:"-I$bgfx_dir/include" --passC:"-I$bx_dir/include" \
  --passC:"$sdl_cflags" \
  --passL:"$build_dir/bgfx.o" --passL:"$build_dir/libbimg.a" \
  --passL:"$build_dir/bx.o" --passL:-lstdc++ --passL:-pthread \
  --passL:-ldl --passL:-lm --passL:"$sdl_libs" \
  examples/sdl_clear.nim "$demo_frames"
