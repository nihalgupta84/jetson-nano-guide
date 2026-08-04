# Jetson Nano AI Server v1.0.0

First stable release of the reproducible Jetson Nano AI server guide.

## Highlights

- CUDA-enabled `llama.cpp` build for JetPack 4 / CUDA 10.2 on Tegra X1.
- Verified GPU offload and CPU-versus-GPU benchmarks.
- OpenAI-compatible `llama-server` API managed by systemd.
- Open WebUI deployment on ARM64 Docker with persistent storage under `/data`.
- Secure internet access through Cloudflare Tunnel and Cloudflare Access at `ai.nihalgupta.me`.
- Local RAG with PDF ingestion, embeddings, vector retrieval, and cited answers.
- Switchable Qwen, SmolLM2, and QwenCoder profiles with friendly API aliases.
- Conservative 768-token context configuration for the 4 GB Nano.
- Unified `jetson-ai` administration command for status, health, logs, storage, backups, restarts, and model switching.
- Weekly verified Open WebUI backups with retention.
- Recovery and troubleshooting notes for Docker networking, Open WebUI startup, tool-calling compatibility, memory pressure, and model loading.

## Verified models

- Qwen2.5-0.5B-Instruct Q4_K_M
- SmolLM2-360M-Instruct Q4_K_M
- Qwen2.5-Coder-0.5B-Instruct Q4_K_M

Only one generation model is loaded at a time to remain within the Nano's shared 4 GB memory limit.

## Stable management commands

```bash
sudo jetson-ai status
sudo jetson-ai health
sudo jetson-ai model qwen
sudo jetson-ai model smol
sudo jetson-ai model coder
sudo jetson-ai storage
sudo jetson-ai logs llama
sudo jetson-ai logs webui
sudo jetson-ai backup
sudo jetson-ai restart
```

## Platform baseline

- NVIDIA Jetson Nano, Tegra X1, compute capability 5.3
- Ubuntu 18.04 / JetPack 4 generation
- CUDA 10.2
- `llama.cpp` tag `b5050`, commit `23106f94e`
- Open WebUI ARM64 Docker deployment
- Data and Docker root stored on `/data`

## Operational notes

- Keep Open WebUI Builtin Tools disabled for the pinned llama.cpp backend.
- Use Legacy function calling in Open WebUI.
- Monitor swap and storage before adding larger models or document collections.
- The Open WebUI backup archives include accounts, settings, chats, uploads, knowledge bases, vector data, and embedding cache.

## Release commit

This release is intended to be tagged from the current stable `main` branch after the 768-token context update.
