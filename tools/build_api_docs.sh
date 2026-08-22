#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
set -eu

if [ "$#" -gt 1 ]; then
  echo "usage: $0 [output-directory]" >&2
  exit 2
fi

output_directory=${1:-build/api}
mkdir -p "$output_directory"

nim doc --path:. --outdir:"$output_directory" bgfx.nim

if [ ! -f "$output_directory/bgfx.html" ]; then
  echo "API reference was not produced" >&2
  exit 1
fi

echo "API reference: $output_directory/bgfx.html"
