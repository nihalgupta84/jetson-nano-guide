# 6. Running models

## First verified model

SmolLM2-360M-Instruct Q4_K_M was used as the initial proof of operation.

Recommended initial settings:

```text
GPU layers: 99, meaning offload all layers that fit
Context: 512
CPU threads: 4
Generated tokens: 128
```

Example:

```bash
/data/llama.cpp/build-nano/bin/llama-cli \
  -m /data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf \
  -ngl 99 \
  -c 512 \
  -t 4 \
  -n 128
```

## Evidence of success

A successful run should contain:

```text
found 1 CUDA devices
Device 0: NVIDIA Tegra X1, compute capability 5.3
offloading 32 repeating layers to GPU
offloading output layer to GPU
offloaded 33/33 layers to GPU
```

Monitor GPU utilization in another terminal:

```bash
sudo tegrastats
```

`GR3D_FREQ` and GPU power should rise during inference.
