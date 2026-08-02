# Running `llama-server` on the Jetson Nano

This chapter documents the verified browser and OpenAI-compatible API setup using the CUDA-enabled `llama.cpp` build.

## Verified environment

- Device: NVIDIA Jetson Nano Developer Kit, 4 GB
- `llama.cpp`: b5050, commit `23106f94e`
- CUDA backend: enabled
- Model: Qwen2.5-0.5B-Instruct Q4_K_M
- Model path: `/data/models/qwen2.5-0.5b-instruct-q4_k_m.gguf`
- LAN address observed during testing: `192.168.5.24`
- Tailscale address observed during testing: `100.68.143.73`
- Server port: `8080`

Do not rely permanently on the listed IP addresses because DHCP or network configuration can change them. Check current addresses with:

```bash
hostname -I
```

## Confirm the server binary

```bash
cd /data/llama.cpp
ls -lh build-nano/bin/llama-server
./build-nano/bin/llama-server --help | head -40
```

The help command should initialize CUDA and detect the NVIDIA Tegra X1 GPU.

## Start the Qwen server

```bash
cd /data/llama.cpp

./build-nano/bin/llama-server \
  -m /data/models/qwen2.5-0.5b-instruct-q4_k_m.gguf \
  -ngl 99 \
  -c 512 \
  -t 4 \
  -n 256 \
  --host 0.0.0.0 \
  --port 8080
```

`--host 0.0.0.0` allows access through the Nano's network interfaces. Do not enter `0.0.0.0` in a browser; use the Nano's actual LAN or Tailscale address.

## Browser access

On the same local network, open:

```text
http://<NANO_LAN_IP>:8080
```

For the verified session, this was:

```text
http://192.168.5.24:8080
```

Through Tailscale, use:

```text
http://<NANO_TAILSCALE_IP>:8080
```

The verified Tailscale address was:

```text
http://100.68.143.73:8080
```

The browser interface was verified to open and return model responses.

## Health check

From another terminal on the Nano:

```bash
curl http://127.0.0.1:8080/health
```

Confirm the listening socket:

```bash
ss -lntp | grep 8080
```

Expected binding:

```text
0.0.0.0:8080
```

## OpenAI-compatible API test

```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-0.5b-instruct",
    "messages": [
      {
        "role": "system",
        "content": "You are a concise and accurate technical assistant."
      },
      {
        "role": "user",
        "content": "Explain the NVIDIA Jetson Nano in three accurate points."
      }
    ],
    "temperature": 0.3,
    "max_tokens": 120
  }'
```

A lower temperature such as `0.3` is recommended for more deterministic technical answers from this small model.

## Windows PowerShell test

```powershell
$body = @{
    model = "qwen2.5-0.5b-instruct"
    messages = @(
        @{
            role = "system"
            content = "You are a concise and accurate technical assistant."
        },
        @{
            role = "user"
            content = "Explain what edge AI means."
        }
    )
    temperature = 0.3
    max_tokens = 120
} | ConvertTo-Json -Depth 5

Invoke-RestMethod `
    -Uri "http://<NANO_IP>:8080/v1/chat/completions" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

## Monitoring

Use a second terminal during requests:

```bash
sudo tegrastats
```

For Qwen2.5-0.5B full offload, previous tests showed GPU utilization near 98–99%, GPU clock near 921 MHz, and temperatures well below throttling levels.

## Faster SmolLM2 alternative

```bash
cd /data/llama.cpp

./build-nano/bin/llama-server \
  -m /data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf \
  -ngl 99 \
  -c 512 \
  -t 4 \
  -n 256 \
  --host 0.0.0.0 \
  --port 8080
```

Stop the active server with `Ctrl+C` before starting another model on the same port.

## Troubleshooting

### Browser cannot connect

```bash
ss -lntp | grep 8080
sudo ufw status
```

If UFW is active:

```bash
sudo ufw allow 8080/tcp
```

From Windows:

```powershell
Test-NetConnection <NANO_IP> -Port 8080
```

### Server exits because of memory pressure

- Stop the graphical display manager when working over SSH.
- Keep context at `512` initially.
- Use one model server at a time.
- Prefer SmolLM2 when memory is tight.
- Check `free -h` and `sudo tegrastats`.

### Security note

Binding to `0.0.0.0` exposes the server to reachable devices on the active networks. Do not expose port 8080 directly to the public internet without authentication, firewall restrictions, and a secure reverse proxy.
