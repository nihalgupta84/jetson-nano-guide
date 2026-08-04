# Multi-model switching: Qwen2.5 and SmolLM2

This guide documents the verified one-model-at-a-time switching setup for the 4 GB Jetson Nano.

## Why one model at a time

The Nano uses unified memory shared by Linux, CPU workloads, CUDA, Open WebUI, embeddings, and the LLM. Keeping Qwen2.5-0.5B and SmolLM2-360M loaded simultaneously would increase memory pressure and swap use. The safer design keeps one `llama-server` process active and changes its model configuration before restarting it.

## Verified models

- Qwen2.5-0.5B-Instruct Q4_K_M: `/data/models/qwen2.5-0.5b-instruct-q4_k_m.gguf`
- SmolLM2-360M-Instruct Q4_K_M: `/data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf`

Previously measured CUDA generation speeds:

- Qwen2.5-0.5B: about 11.35 tokens/s
- SmolLM2-360M: about 14.13 tokens/s

Qwen provides better general response quality, while SmolLM2 is faster and uses less memory.

## Configuration file

Create `/etc/jetson-ai/llama-server.env`:

```ini
MODEL_NAME=qwen
MODEL_PATH=/data/models/qwen2.5-0.5b-instruct-q4_k_m.gguf
HOST=172.17.0.1
PORT=8080
CTX_SIZE=512
THREADS=4
GPU_LAYERS=99
MAX_TOKENS=256
```

The server listens only on the Docker bridge so Open WebUI can reach it without exposing the raw llama.cpp endpoint to the LAN.

## Install repository scripts

```bash
sudo install -m 755 scripts/start-jetson-llama-server.sh \
  /usr/local/sbin/start-jetson-llama-server.sh

sudo install -m 750 scripts/switch-jetson-model \
  /usr/local/sbin/switch-jetson-model

sudo install -m 644 systemd/llama-server.service \
  /etc/systemd/system/llama-server.service

sudo systemctl daemon-reload
sudo systemctl enable --now llama-server
```

## Commands

Check status:

```bash
sudo switch-jetson-model status
```

Switch to SmolLM2:

```bash
sudo switch-jetson-model smol
```

Switch to Qwen:

```bash
sudo switch-jetson-model qwen
```

The switcher:

1. Validates that the requested GGUF file exists.
2. Backs up the previous environment file.
3. Writes the new model configuration atomically.
4. Restarts `llama-server`.
5. Waits for `/health` to return success.
6. Restores the previous configuration if the new model does not become healthy.

A temporary HTTP 503 response is normal while a model is loading. Readiness is confirmed by:

```bash
curl -fsS http://172.17.0.1:8080/health
```

Expected response:

```json
{"status":"ok"}
```

## Verified switching result

The following sequence was tested successfully:

```text
Qwen -> SmolLM2 -> Qwen
```

For both models, the switcher reported:

```text
Model is ready
active
Health: OK
```

## Open WebUI behavior

Open WebUI discovers only the model currently exposed by `llama-server`. This means:

- When Qwen is active, the Qwen base model is available.
- When SmolLM2 is active, the SmolLM2 base model is available.
- `Arena Model` is an Open WebUI comparison mode and is not SmolLM2.

After every switch:

1. Refresh Open WebUI.
2. Start a new chat.
3. Select the currently available model.
4. Keep Builtin Tools disabled.
5. Keep Function Calling set to Legacy.

Friendly model presets such as `Qwen` and `SmolLM2` may be created in Workspace -> Models. A preset depends on its underlying base model, so it is usable only while that base model is currently served.

## Persistent data

Switching the generation model does not alter:

- Open WebUI accounts
- Chats
- Uploaded PDFs
- Knowledge bases
- Embeddings
- Vector database
- Cloudflare configuration

Those remain inside the persistent Open WebUI Docker volume.
