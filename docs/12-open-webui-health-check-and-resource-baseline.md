# Open WebUI health check and resource baseline

Date: 2026-08-02

This document records the verified persistent state of the Jetson Nano AI stack after adding Open WebUI.

## Verified services

The following services and endpoints were confirmed healthy:

```text
[OK] llama-server is active
[OK] cloudflared is active
[OK] docker is active
[INFO] open-webui state=running health=healthy
[OK] llama-server responded
[OK] Open WebUI responded
[OK] Public endpoint responded
```

Public endpoint:

```text
https://ai.nihalgupta.me
```

Local endpoints:

```text
llama-server: http://172.17.0.1:8080/health
Open WebUI:    http://127.0.0.1:3000/health
```

## Startup persistence

Verified service startup configuration:

```text
llama-server: enabled
cloudflared:  enabled
docker:       enabled
open-webui:   restart=unless-stopped
```

This means the complete stack should recover automatically after reboot or power restoration.

## Health-check script

Installed at:

```text
/usr/local/sbin/check-jetson-ai-stack.sh
```

Run manually with:

```bash
sudo /usr/local/sbin/check-jetson-ai-stack.sh
```

The script checks:

1. `llama-server.service`
2. `cloudflared.service`
3. `docker.service`
4. Open WebUI container state and Docker health status
5. Local llama-server health endpoint
6. Local Open WebUI health endpoint
7. Public Cloudflare endpoint
8. RAM, swap and filesystem usage

## Resource baseline

Measured after the full stack was running:

```text
Memory total:     3.9 GiB
Memory used:      3.1 GiB
Memory available: 558 MiB
Swap total:       1.9 GiB
Swap used:        801 MiB
```

Storage:

```text
Root SD card: 14 GiB total, 12 GiB used, 1.5 GiB free, 89% used
/data SSD:    30 GiB total, 21 GiB used, 7.7 GiB free, 73% used
```

## Important operational note

The system is healthy, but memory headroom is limited. Open WebUI, the local embedding model, Qwen2.5-0.5B, Docker, Cloudflare Tunnel and the operating system together leave roughly 558 MiB available RAM while using about 801 MiB of swap.

Before enabling heavier RAG workloads, larger embedding models, image models or additional containers:

1. Monitor `free -h` and `sudo tegrastats`.
2. Keep `/data` as the Docker data root.
3. Avoid filling the SD-card root partition beyond its current 89% usage.
4. Test document ingestion first with a small text or PDF file.
5. Watch for container restarts or OOM events.

## Open WebUI compatibility setting

For the pinned llama.cpp b5050 backend and Qwen2.5-0.5B model, normal chat required:

```text
Function Calling: Legacy
Builtin Tools: Off
Web Search: Off
Code Interpreter: Off
Image Generation: Off
```

This avoids the backend error:

```text
Cannot use tools with stream
```

Normal streaming chat works after disabling injected tools.
