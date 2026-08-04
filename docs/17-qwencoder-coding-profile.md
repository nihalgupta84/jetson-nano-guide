# QwenCoder coding profile

This guide adds `Qwen2.5-Coder-0.5B-Instruct-Q4_K_M` as a third switchable `llama.cpp` profile on the 4 GB Jetson Nano.

## Model file

```text
/data/models/qwen2.5-coder-0.5b-instruct-q4_k_m.gguf
```

Observed file size:

```text
469 MB on disk
462.96 MiB reported by llama.cpp
630.17 million parameters
```

## Verified CUDA loading

The direct `llama-cli` test detected the Tegra X1 GPU and reported:

```text
offloading 24 repeating layers to GPU
offloading output layer to GPU
offloaded 25/25 layers to GPU
```

The model then generated a valid typed Python `is_prime()` implementation. A short `-n 128` run may truncate the explanation; use `-n 256` for a more complete response.

## Switcher profile

The installed switcher supports:

```bash
sudo switch-jetson-model qwen
sudo switch-jetson-model smol
sudo switch-jetson-model coder
sudo switch-jetson-model status
```

The coding profile writes:

```text
MODEL_NAME=coder
MODEL_ALIAS=QwenCoder
MODEL_PATH=/data/models/qwen2.5-coder-0.5b-instruct-q4_k_m.gguf
```

The alias is passed to `llama-server`, so `/v1/models` and Open WebUI display `QwenCoder` rather than the full GGUF path.

## Verified runtime state

The following state was verified after switching:

```text
Configured model: coder
Display alias: QwenCoder
Service: active
Health: OK
API model: QwenCoder
```

`/v1/models` returned an entry with:

```json
{"id":"QwenCoder","owned_by":"llamacpp"}
```

## Open WebUI use

After switching:

1. Refresh Open WebUI.
2. Start a new chat.
3. Select `QwenCoder`.
4. Keep Builtin Tools disabled.
5. Keep Function Calling set to Legacy for compatibility with the pinned `llama.cpp` build.

This 0.5B coding model is appropriate for focused functions, syntax correction, boilerplate, explanations, and small debugging tasks. It should not be treated as a replacement for a larger repository-scale coding model.
