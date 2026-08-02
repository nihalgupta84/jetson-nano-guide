# 5. Building llama.cpp with CUDA 10.2

## Pin the source

```bash
cd /data
git clone https://github.com/ggml-org/llama.cpp.git
cd llama.cpp
git checkout 23106f94e
git checkout -b jetson-nano-cuda
```

The checkout should report tag `b5050` and commit `23106f94e`.

## Why a pinned revision is required

The current upstream source required the CUDA17 language dialect. CUDA 10.2 on Jetson Nano could not satisfy that configuration. The pinned revision can be configured with CUDA C++14 after applying compatibility changes.

## Required compatibility changes

1. Remove the unavailable `cuda_bf16.h` include.
2. Replace active `nv_bfloat16` uses in selected kernels with `half`.
3. Remove unsupported `constexpr` usage on a device constant.
4. Comment unsupported `__builtin_assume` calls.

Use `scripts/05-patch-llama-cuda10.sh` rather than editing manually.

## Configure and build

Use `scripts/06-build-llama-cuda.sh`. It sets:

```text
C compiler: /data/gcc-8.5/bin/gcc
C++ compiler: /data/gcc-8.5/bin/g++
CUDA host compiler: /data/gcc-8.5/bin/g++
CUDA compiler: /usr/local/cuda-10.2/bin/nvcc
CUDA architecture: 53
CUDA standard: 14
```

Build with one parallel job to reduce memory pressure.
