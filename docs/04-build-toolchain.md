# 4. Build toolchain

## Why CMake was upgraded

Ubuntu 18.04 supplied CMake 3.10.2. The selected `llama.cpp` revision required a newer CMake. CMake 3.22.6 was installed under `/data` without replacing `/usr/bin/cmake`.

## Why GCC 8.5 was built

GCC 7.5 failed on ARM NEON multi-register load intrinsics used by the selected `llama.cpp` revision, including `vld1q_s8_x4` and related forms. GCC 8.5 successfully provided the required compiler support while remaining compatible with CUDA 10.2.

The custom compiler is installed under:

```text
/data/gcc-8.5/bin/gcc
/data/gcc-8.5/bin/g++
```

The system compiler is intentionally left unchanged.
