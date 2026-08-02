#!/usr/bin/env bash
set -euo pipefail

ROOT=/data/llama.cpp
BUILD=$ROOT/build-nano
CMAKE=/data/cmake-3.22.6/bin/cmake
GCC=/data/gcc-8.5/bin/gcc
GXX=/data/gcc-8.5/bin/g++
NVCC=/usr/local/cuda-10.2/bin/nvcc

for p in "$CMAKE" "$GCC" "$GXX" "$NVCC"; do
  [[ -x "$p" ]] || { echo "Missing executable: $p" >&2; exit 1; }
done

cd "$ROOT"
rm -rf "$BUILD"

CC="$GCC" CXX="$GXX" "$CMAKE" -S . -B "$BUILD" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="$GCC" \
  -DCMAKE_CXX_COMPILER="$GXX" \
  -DCMAKE_CUDA_HOST_COMPILER="$GXX" \
  -DCMAKE_CUDA_COMPILER="$NVCC" \
  -DCMAKE_CUDA_ARCHITECTURES=53 \
  -DCMAKE_CUDA_STANDARD=14 \
  -DCMAKE_CUDA_STANDARD_REQUIRED=ON \
  -DGGML_CUDA=ON \
  -DGGML_CPU_ARM_ARCH=armv8-a \
  -DGGML_NATIVE=OFF \
  -DGGML_CUDA_GRAPHS=OFF \
  -DGGML_CUDA_FA=OFF \
  -DGGML_CUDA_NCCL=OFF \
  -DLLAMA_CURL=OFF \
  -DGGML_CCACHE=OFF

"$CMAKE" --build "$BUILD" --config Release -j1
