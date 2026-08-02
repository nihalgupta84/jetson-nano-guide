#!/usr/bin/env bash
set -euo pipefail

ROOT=/data/llama.cpp
cd "$ROOT"

# Make this script safe to run more than once.
sed -i 's|^[[:space:]]*#include <cuda_bf16.h>|// #include <cuda_bf16.h>|' \
  ggml/src/ggml-cuda/vendors/cuda.h

sed -i 's/nv_bfloat16/half/g' \
  ggml/src/ggml-cuda/convert.cu \
  ggml/src/ggml-cuda/mmv.cu

sed -i \
  's/static constexpr __device__ int8_t kvalues_iq4nl/static __device__ int8_t kvalues_iq4nl/' \
  ggml/src/ggml-cuda/common.cuh

for f in \
  ggml/src/ggml-cuda/fattn-common.cuh \
  ggml/src/ggml-cuda/fattn-vec-f32.cuh \
  ggml/src/ggml-cuda/fattn-vec-f16.cuh; do
  sed -i '/__builtin_assume/{ /^[[:space:]]*\/\//! s|^[[:space:]]*|// |; }' "$f"
done

echo 'Remaining BF16 references:'
grep -RIn --include='*.cu' --include='*.cuh' --include='*.h' \
  'cuda_bf16\|nv_bfloat16' ggml/src/ggml-cuda || true

echo 'Patch complete.'
