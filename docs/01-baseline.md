# 1. Verified baseline

## Hardware

The tested system is an NVIDIA Jetson Nano Developer Kit with 4 GB shared LPDDR4 memory. The CPU and GPU use the same physical memory pool.

## Operating system and NVIDIA stack

```text
Model: NVIDIA Jetson Nano Developer Kit
Architecture: aarch64
Ubuntu: 18.04.6 LTS
L4T: 32.6.1
CUDA compiler: 10.2.300
GPU: NVIDIA Tegra X1
Compute capability: 5.3
```

## Storage observed during setup

```text
/dev/mmcblk0p1  approximately 14 GB root filesystem
/data           approximately 30 GB secondary storage
```

The root filesystem had only about 1.5 GB free. All large source trees, compilers, models, and builds were therefore placed under `/data`.

## Working local-LLM stack

```text
/data/cmake-3.22.6
/data/gcc-8.5
/data/llama.cpp
/data/models
```

The successful `llama.cpp` version was:

```text
tag: b5050
commit: 23106f94e
```

The first verified model was SmolLM2-360M-Instruct Q4_K_M. It loaded all 33 computational layers onto CUDA.
