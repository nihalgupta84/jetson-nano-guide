# 7. Troubleshooting

## `nvcc: command not found`

Cause: CUDA binaries were not in `PATH`.

Fix:

```bash
export PATH=/usr/local/cuda-10.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH
```

## `Target ggml-cuda requires CUDA17`

Cause: the upstream checkout was too new for CUDA 10.2.

Fix: use tag `b5050`, commit `23106f94e`, and configure with CUDA standard 14.

## `fatal error: cuda_bf16.h: No such file or directory`

Cause: CUDA 10.2 lacks that header.

Fix: apply `scripts/05-patch-llama-cuda10.sh`.

## ARM NEON errors such as `vld1q_s8_x4`

Cause: GCC 7.5 did not provide the required intrinsics in this build context.

Fix: compile with GCC/G++ 8.5 and use it as the CUDA host compiler.

## Model file cannot be opened

Cause: the path is wrong or `model.gguf` is only a placeholder.

Fix:

```bash
ls -lh /data/models
```

Use the exact downloaded filename.

## CUDA initializes but GPU utilization remains zero

Confirm that the runtime reports layers being offloaded. Use `-ngl 99`. Watch `sudo tegrastats` during generation, not only during program startup.
