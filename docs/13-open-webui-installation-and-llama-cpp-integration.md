# Open WebUI on Jetson Nano with llama.cpp

This chapter records the tested Open WebUI deployment used with the CUDA-enabled `llama-server` on a 4 GB Jetson Nano.

## Verified architecture

```text
https://ai.nihalgupta.me
        |
Cloudflare Access
        |
Cloudflare Tunnel
        |
Open WebUI on 127.0.0.1:3000
        |
Docker bridge
        |
llama-server on 172.17.0.1:8080
        |
Qwen2.5-0.5B-Instruct Q4_K_M
        |
CUDA on NVIDIA Tegra X1
```

## Tested software

- Docker 20.10.21
- Architecture: `aarch64`
- Open WebUI image: `ghcr.io/open-webui/open-webui:main-slim`
- Open WebUI version observed after startup: `v0.11.0`
- llama.cpp: tag `b5050`, commit `23106f94e`
- Backend model: Qwen2.5-0.5B-Instruct Q4_K_M

## Resource state before installation

The Nano had approximately:

```text
RAM: 3.9 GiB total, about 1.1 GiB available
Swap: 1.9 GiB total
/data: 13 GiB free before the image and embedding download
```

Because the Nano has only 4 GB RAM, the slim Open WebUI image and explicit memory limits were used.

## 1. Bind llama-server to the Docker bridge only

Find the Docker bridge address:

```bash
ip -4 addr show docker0
```

Expected address:

```text
172.17.0.1
```

Update `/etc/systemd/system/llama-server.service` so the server listens on the Docker bridge instead of every network interface:

```text
--host 172.17.0.1
--port 8080
```

Reload and restart:

```bash
sudo systemctl daemon-reload
sudo systemctl restart llama-server
sudo systemctl status llama-server --no-pager
```

Verify:

```bash
curl http://172.17.0.1:8080/health
ss -lntp | grep 8080
```

The listener should be `172.17.0.1:8080`, not `0.0.0.0:8080`.

## 2. Create persistent Open WebUI data and secret

```bash
sudo mkdir -p /data/open-webui
sudo chmod 700 /data/open-webui

openssl rand -hex 32 |
  sudo tee /data/open-webui/secret-key >/dev/null

sudo chmod 600 /data/open-webui/secret-key
```

Never commit the secret key.

## 3. Pull the ARM64 slim image

```bash
docker pull ghcr.io/open-webui/open-webui:main-slim
```

The tested image digest was:

```text
sha256:f67aea542a85e82cfab8c1de0719487b1566bffbb53c2b5448223611a16889dc
```

## 4. Create the container

```bash
WEBUI_SECRET_KEY="$(sudo cat /data/open-webui/secret-key)"

docker run -d \
  --name open-webui \
  --restart unless-stopped \
  --add-host=host.docker.internal:host-gateway \
  -p 127.0.0.1:3000:8080 \
  -v open-webui:/app/backend/data \
  --memory=900m \
  --memory-swap=1400m \
  -e WEBUI_SECRET_KEY="$WEBUI_SECRET_KEY" \
  -e WEBUI_URL="https://ai.nihalgupta.me" \
  -e ENABLE_OLLAMA_API=False \
  -e ENABLE_OPENAI_API=True \
  -e OPENAI_API_BASE_URL="http://host.docker.internal:8080/v1" \
  -e OPENAI_API_KEY="none" \
  -e DATABASE_POOL_SIZE=2 \
  -e DATABASE_SQLITE_PRAGMA_CACHE_SIZE=-2000 \
  -e DATABASE_SQLITE_PRAGMA_MMAP_SIZE=0 \
  -e DATABASE_SQLITE_PRAGMA_TEMP_STORE=FILE \
  ghcr.io/open-webui/open-webui:main-slim
```

Important details:

- Open WebUI is reachable only on `127.0.0.1:3000`.
- `host.docker.internal` resolves to the Docker host through `host-gateway`.
- The OpenAI-compatible backend URL is `http://host.docker.internal:8080/v1`.
- `--restart unless-stopped` restores the container after reboot.
- The container is capped at 900 MiB RAM and 1.4 GiB RAM-plus-swap.

## 5. First startup

Follow logs:

```bash
docker logs -f open-webui
```

The first startup performed database migrations and downloaded the default embedding model:

```text
sentence-transformers/all-MiniLM-L6-v2
```

The download completed successfully, and the model was loaded from the persistent Open WebUI data volume.

The following warning appeared while loading the embedding model:

```text
embeddings.position_ids | UNEXPECTED
```

It did not prevent startup.

The Hugging Face unauthenticated-request warning also did not prevent the public model download.

## 6. Verify readiness

```bash
curl -fsS http://127.0.0.1:3000/health
```

Expected:

```json
{"status":true}
```

Check the container:

```bash
docker ps --filter name=open-webui
```

Expected status:

```text
Up ... (healthy)
```

Check resource usage:

```bash
docker stats --no-stream open-webui
free -h
df -h / /data
```

## 7. Cloudflare route

The existing public hostname remained:

```text
https://ai.nihalgupta.me
```

The Cloudflare Tunnel origin was changed from:

```text
http://127.0.0.1:8080
```

to:

```text
http://127.0.0.1:3000
```

Cloudflare Access authentication remained enabled.

## 8. Open WebUI backend connection

The backend connection is:

```text
Base URL: http://host.docker.internal:8080/v1
API key: none
```

Open WebUI successfully discovered the Qwen model exposed by `llama-server`.

## 9. Required compatibility settings for llama.cpp b5050

The pinned `llama.cpp` backend returned:

```text
Cannot use tools with stream
```

when Open WebUI sent built-in tool definitions together with streaming.

The working configuration is:

```text
Function Calling: Legacy
Builtin Tools: Off
Web Search: Off
Code Interpreter: Off
Image Generation: Off
Streaming: On
File Upload: On
File Context: On
Citations: optional
```

The critical fix was disabling **Builtin Tools**. Changing function calling to Legacy alone was not sufficient while built-in tools remained enabled.

After applying these settings and starting a new chat, normal streaming chat worked.

## 10. Verified final state

The stack passed all checks:

```text
llama-server: active
cloudflared: active
Docker: active
Open WebUI: running and healthy
llama-server health endpoint: responding
Open WebUI health endpoint: responding
Public endpoint: responding
```

The public interface remained accessible from a phone using mobile data, proving access from outside the local Wi-Fi network.

## 11. Resource baseline after installation

Observed after the full stack was running:

```text
RAM: 3.1 GiB used of 3.9 GiB
Available RAM: about 558 MiB
Swap used: about 801 MiB of 1.9 GiB
Root filesystem: 89% used
/data filesystem: 73% used
```

The stack is functional, but memory headroom is limited. Future RAG tests should begin with a single short document and resource monitoring enabled.
