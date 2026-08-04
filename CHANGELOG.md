# Changelog

## 2026-08-04 — Verified multi-model switching

- Added a configurable `llama-server` launcher driven by `/etc/jetson-ai/llama-server.env`.
- Added the `switch-jetson-model` command with `qwen`, `smol`, and `status` modes.
- Added health-check waiting, atomic configuration replacement, and automatic rollback to the previous model configuration.
- Added a `systemd` service template that waits for `/data` and starts the selected model automatically.
- Verified the complete switching sequence `Qwen -> SmolLM2 -> Qwen` with the service active and `/health` returning OK.
- Documented Open WebUI model discovery, friendly presets, and the distinction between SmolLM2 and Arena Model.

## 2026-08-02 — First successful local RAG test

- Created an Open WebUI knowledge base and uploaded a PDF.
- Verified local text extraction, chunking, embedding generation, vector retrieval, and document-grounded answers.
- Confirmed Qwen2.5-0.5B-Instruct can answer using retrieved PDF context through the CUDA-enabled `llama-server` backend.
- Recorded low-memory operating constraints and a gradual document-scaling plan for the 4 GB Nano.
- Added validation questions and compatibility settings for reliable document chat.

## 2026-08-02 — Open WebUI and secure remote AI platform

- Added verified Qwen2.5-0.5B and SmolLM2 CPU-versus-GPU benchmarks.
- Added `llama-server` browser and OpenAI-compatible API setup.
- Added Cloudflare Tunnel and Access configuration for `https://ai.nihalgupta.me`.
- Added persistent `systemd` services for `llama-server` and `cloudflared`.
- Added Open WebUI `main-slim` deployment for ARM64 Docker.
- Bound Open WebUI to `127.0.0.1:3000` and `llama-server` to the Docker bridge at `172.17.0.1:8080`.
- Added low-memory Docker limits and SQLite settings for the 4 GB Nano.
- Recorded first-run SQLite migrations and `all-MiniLM-L6-v2` embedding download.
- Documented recovery from Docker `libnetwork.endpointCnt` corruption and container-name conflicts.
- Documented the `Cannot use tools with stream` compatibility issue and verified fix: Legacy function calling plus Builtin Tools disabled.
- Added stack health checks covering systemd services, Docker health, local endpoints, public endpoint, RAM, swap, and storage.
- Verified access from outside the local Wi-Fi network and automatic recovery after reboot.

## 2026-08-02 — Initial reproducible baseline

- Documented Jetson Nano hardware and software baseline.
- Added storage, CMake 3.22.6, and GCC 8.5 setup.
- Pinned `llama.cpp` to tag `b5050`, commit `23106f94e`.
- Added CUDA 10.2 compatibility patching procedure.
- Added build, verification, model-download, execution, and benchmark scripts.
- Recorded successful CUDA detection and full 33/33-layer GPU offload.
