# Deferred phase: DGX container backend without host access

## Goal

Use the Jetson Nano as the permanent authenticated frontend while running stronger OpenAI-compatible models inside the existing `docker_14` container on the DGX.

The design must continue working even if future access is limited to the container only, with no DGX-host sudo, no host SSH, no host Docker commands, and no host networking changes.

## Target architecture

```text
Phone / Laptop
      |
Cloudflare Access
      |
Open WebUI on Jetson Nano
      |
      +-- Jetson llama.cpp
      |     Qwen / SmolLM2 / QwenCoder
      |
      +-- Jetson reverse-forward listener
              |
        SSH reverse tunnel
              |
        vLLM inside docker_14
              |
        A100 MIG 7g.40GB
```

Only the Jetson is exposed through Cloudflare. The DGX container remains private and initiates the outbound SSH connection to the Jetson.

## Why this design

- It does not require DGX-host sudo access.
- It does not require host-level Tailscale.
- It does not require recreating the Docker container with an additional published port.
- It does not expose vLLM directly to the public internet.
- All DGX-side files can live under persistent `/workspace` storage.
- The Jetson remains the single browser interface and authentication boundary.

## Confirmed environment

Inside the persistent container:

```text
Docker container name: nihal_amity
Container hostname: docker_14
Container networks: 172.17.0.2 and 172.30.0.2
Visible accelerator: A100-SXM4-40GB, MIG 7g.40GB
Persistent storage: /workspace
```

Available vLLM environments:

```text
/workspace/miniconda3/envs/language     vLLM 0.21.0
/workspace/miniconda3/envs/hermes_vllm  vLLM 0.23.0
```

The `hermes_vllm` environment currently reports a PyTorch/driver compatibility warning, so the known-working `language` environment should be evaluated first when this phase resumes.

## Deferred implementation

Create the following persistent structure inside the container:

```text
/workspace/services/dgx-llm/
├── config/
├── logs/
├── start-vllm.sh
├── start-jetson-tunnel.sh
├── status.sh
└── stop.sh
```

The vLLM server should initially bind only inside the container:

```text
127.0.0.1:8001
```

The container will then publish it to the Jetson using an SSH reverse tunnel:

```bash
ssh -N \
  -R 127.0.0.1:18001:127.0.0.1:8001 \
  jetson-nano
```

The final listener address may need to be changed to `172.17.0.1:18001` or another Jetson-reachable address so the Open WebUI Docker container can connect to it. This must be tested before making the tunnel persistent.

Open WebUI will use an additional OpenAI-compatible connection similar to:

```text
http://172.17.0.1:18001/v1
```

The exact URL will be selected after validating reachability from inside the Open WebUI container.

## Process supervision without host systemd

Because future access may be container-only, do not depend on DGX-host services. Use one of:

- `tmux` sessions with restart scripts;
- `supervisord` stored under `/workspace`;
- a container-local watchdog script;
- an existing container startup hook, if one is already persistent and under user control.

All logs and configuration must be stored under `/workspace/services/dgx-llm`.

## Prerequisites before resuming

1. The active training experiment must be finished or deliberately stopped.
2. GPU memory availability must be checked with `nvidia-smi`.
3. A suitable model must be selected based on available MIG memory.
4. vLLM must be tested locally inside the container before creating the tunnel.
5. The container must be able to SSH to the Jetson without interactive password entry.
6. The reverse-forward listener must be reachable from the Open WebUI container on the Jetson.

## Safety rules

- Do not modify the existing DGX-host service on `127.0.0.1:8000`; it belongs to the separate Local Medical AI application.
- Do not start vLLM while important training is using the same MIG device without checking memory and workload impact.
- Do not expose the DGX model endpoint directly to the internet.
- Do not place SSH private keys, API keys, model credentials, or tunnel secrets in this repository.
- Do not make DGX-host access a permanent requirement.

## Completion criteria

This phase is complete when:

1. vLLM runs inside `docker_14` and returns `/v1/models` and `/v1/chat/completions`.
2. The reverse SSH tunnel reconnects automatically from the container to the Jetson.
3. Open WebUI lists both Jetson and DGX-backed models.
4. A test prompt completes through the DGX model from the public Open WebUI interface.
5. Restart and recovery instructions work using container access only.

## Current status

Deferred until the A100-backed container is free. No DGX-host modification is required or planned.
