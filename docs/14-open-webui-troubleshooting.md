# Open WebUI Troubleshooting on Jetson Nano

This chapter records the actual failures encountered during the tested installation and the fixes that worked.

## 1. `No such container: open-webui`

Cause: the image had been pulled, but the container had not yet been created.

Check:

```bash
docker ps -a --filter name=open-webui
```

Create the container only after the image is available.

## 2. Docker libnetwork error

Observed error:

```text
failed to update store for object type *libnetwork.endpointCnt: Key not found in store
```

This was a stale/corrupt Docker network-state problem, not an Open WebUI application error.

The failed attempt left a container in the `Created` state:

```bash
docker ps -a --filter name=open-webui
```

Recovery:

```bash
docker rm -f open-webui
sudo systemctl restart docker
sudo systemctl status docker --no-pager
```

Verify the default bridge:

```bash
docker network inspect bridge >/dev/null &&
  echo "Docker bridge is healthy"
```

Test container networking:

```bash
docker run --rm hello-world
```

The ARM64 `hello-world` container completed successfully, proving Docker networking had recovered.

If the same error returns, remove only unused networks and restart Docker:

```bash
docker network prune -f
sudo systemctl restart docker
```

Do not delete `/var/lib/docker` or reinstall Docker as the first response.

## 3. Container name conflict

Observed error:

```text
Conflict. The container name "/open-webui" is already in use
```

Cause: a later `docker run` had already created the container successfully.

Check before recreating:

```bash
docker ps -a --filter name=open-webui
```

If the state is `Up`, inspect it instead of recreating:

```bash
docker logs --tail 100 open-webui
docker stats --no-stream open-webui
```

If the state is `Created` or `Exited`, remove it before recreating:

```bash
docker rm -f open-webui
```

## 4. Connection reset during first startup

Observed:

```text
curl: (56) Recv failure: Connection reset by peer
```

At that time, Open WebUI was still running SQLite migrations and had not completed startup. The container was not out of memory.

Follow logs:

```bash
docker logs -f open-webui
```

Use the health endpoint instead of assuming the root page is ready:

```bash
curl -fsS http://127.0.0.1:3000/health
```

Expected when ready:

```json
{"status":true}
```

## 5. Long first startup and Hugging Face downloads

The first startup downloaded 30 files for:

```text
sentence-transformers/all-MiniLM-L6-v2
```

This took several minutes on the Nano. The container remained healthy enough to continue and later completed startup.

The warning about unauthenticated Hugging Face requests can be ignored for this public model unless higher rate limits are required.

## 6. `Cannot use tools with stream`

Observed in Open WebUI chat:

```text
Cannot use tools with stream
```

Cause: Open WebUI was sending tool definitions with a streaming request to the pinned `llama.cpp` b5050 backend.

Changing only Function Calling to Legacy did not fix the issue because Builtin Tools remained enabled.

Working configuration:

```text
Function Calling: Legacy
Builtin Tools: Off
Web Search: Off
Code Interpreter: Off
Image Generation: Off
Streaming: On
```

After changing settings, create a new chat rather than reusing the failed conversation.

## 7. Health verification

```bash
sudo /usr/local/sbin/check-jetson-ai-stack.sh
```

Expected checks:

```text
[OK] llama-server is active
[OK] cloudflared is active
[OK] docker is active
[INFO] open-webui state=running health=healthy
[OK] llama-server responded
[OK] Open WebUI responded
[OK] Public endpoint responded
```

## 8. Resource-pressure warning

After Open WebUI and the embedding model were loaded, observed headroom was limited:

```text
Available RAM: about 558 MiB
Swap used: about 801 MiB
/data free: about 7.7 GiB
Root free: about 1.5 GiB
```

Before adding RAG documents, check:

```bash
free -h
df -h / /data
docker stats --no-stream open-webui
sudo tegrastats
```

Start with one short document and stop if swap usage rises sharply or the container begins restarting.
