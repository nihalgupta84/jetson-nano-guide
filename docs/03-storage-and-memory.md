# 3. Storage and memory planning

The Nano has only 4 GB shared memory. Linux, desktop services, CUDA, model weights, KV cache, and compute buffers all consume this pool.

Use `/data` for:

```text
/data/cmake-3.22.6
/data/gcc-8.5
/data/gcc-8.5.0
/data/gcc-8.5-build
/data/llama.cpp
/data/models
```

Avoid storing model files or build trees on the small root partition.

## Desktop memory

When operating through SSH, the GNOME display manager can be stopped temporarily:

```bash
sudo systemctl stop display-manager
```

Restore it with:

```bash
sudo systemctl start display-manager
```

Stopping the display manager does not guarantee that all graphical-session memory disappears immediately. Use `free -h`, `ps`, and `tegrastats` to inspect the actual state.

## Swap

Swap helps prevent out-of-memory termination but is much slower than RAM. It should be a safety net, not a substitute for fitting the model in memory.
