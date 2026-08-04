# Unified `jetson-ai` Management Command

The Jetson Nano AI stack can be managed through one command installed at:

```text
/usr/local/sbin/jetson-ai
```

Install the repository copy with:

```bash
sudo install -m 750 scripts/jetson-ai /usr/local/sbin/jetson-ai
```

## Supported commands

```bash
sudo jetson-ai status
sudo jetson-ai health
sudo jetson-ai model qwen
sudo jetson-ai model smol
sudo jetson-ai model coder
sudo jetson-ai model status
sudo jetson-ai storage
sudo jetson-ai logs llama
sudo jetson-ai logs webui
sudo jetson-ai logs cloudflare
sudo jetson-ai logs backup
sudo jetson-ai backup
sudo jetson-ai restart
```

## Verified behavior

The command was tested on the working Jetson Nano installation and confirmed to report:

- `llama-server`, `cloudflared`, and Docker service status.
- Open WebUI container state, health, and restart policy.
- Configured model, friendly alias, model path, and API model ID.
- Local llama.cpp health endpoint.
- Local Open WebUI health endpoint.
- Public Cloudflare endpoint.
- RAM and swap usage.
- Root and `/data` filesystem usage.
- Existing Open WebUI backups and the next timer run.
- Docker, model, embedding-cache, and vector-database storage use.

The model command was verified by switching from `QwenCoder` to `Qwen`, waiting for the model to become healthy, and confirming that `/v1/models` returned the friendly alias `Qwen`.

The health command completed with:

```text
Jetson AI stack is healthy.
```

The llama log command showed successful Open WebUI requests to:

```text
POST /v1/chat/completions ... 200
```

## Notes

The command expects the following existing components:

- `/usr/local/sbin/switch-jetson-model`
- `/etc/jetson-ai/llama-server.env`
- `llama-server.service`
- `cloudflared.service`
- Docker container `open-webui`
- `open-webui-backup.service`
- `open-webui-backup.timer`

The public endpoint is currently set to:

```text
https://ai.nihalgupta.me
```

Change `PUBLIC_URL` in the script when deploying under a different hostname.
