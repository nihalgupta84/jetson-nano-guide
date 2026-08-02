# Jetson Nano Local LLM Guide

Reproducible setup for running CUDA-accelerated local LLMs on an NVIDIA Jetson Nano Developer Kit (4 GB) using JetPack 4.6 / L4T 32.6.1, CUDA 10.2, GCC 8.5, CMake 3.22.6, and a pinned `llama.cpp` revision.

## Verified baseline

- Hardware: NVIDIA Jetson Nano Developer Kit, 4 GB
- Architecture: aarch64 / ARM64
- OS: Ubuntu 18.04.6 LTS
- L4T: 32.6.1
- JetPack: 4.6 generation
- CUDA: 10.2.300
- GPU: NVIDIA Tegra X1, Maxwell, compute capability 5.3
- CMake: 3.22.6
- GCC/G++: 8.5.0 installed under `/data/gcc-8.5`
- `llama.cpp`: tag `b5050`, commit `23106f94e`
- First model: SmolLM2-360M-Instruct Q4_K_M GGUF
- Verified offload: 33/33 model layers on CUDA

## Repository layout

- `docs/` — setup, explanations, recovery, troubleshooting
- `scripts/` — reproducible installation, patching, build, verification, benchmark scripts
- `patches/` — source patch documentation
- `configs/` — environment and service templates
- `models/` — model manifest only; model binaries are never committed
- `benchmarks/` — benchmark result templates and future measurements
- `logs/` — sanitized reference logs

## Start here

1. Read [`docs/01-baseline.md`](docs/01-baseline.md).
2. Follow [`docs/02-recovery-from-blank-device.md`](docs/02-recovery-from-blank-device.md).
3. Run scripts in numeric order.
4. Verify with `scripts/07-verify-llama-cuda.sh`.
5. Download a model listed in `models/MODELS.md`.
6. Run `scripts/08-run-smollm2.sh`.

## Important constraints

This guide targets the original Jetson Nano and its JetPack 4.x software stack. Do not blindly substitute JetPack 5/6, a newer CUDA toolkit, a newer `llama.cpp` checkout, or a newer default GCC. Those combinations may not support Nano or CUDA 10.2.

Large generated artifacts are intentionally ignored: GGUF models, GCC sources/build trees, CMake binaries, and `llama.cpp` build outputs.

## Status

The baseline build and full GPU offload were verified on 2026-08-02.
