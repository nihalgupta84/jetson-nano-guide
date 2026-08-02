# Model manifest

Model binaries are not committed to Git.

## Verified first model

```text
Name: SmolLM2-360M-Instruct
Format: GGUF
Quantization: Q4_K_M
Expected filename: SmolLM2-360M-Instruct-Q4_K_M.gguf
Expected location: /data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf
Observed size: approximately 256 MiB
```

Download the GGUF from a trusted Hugging Face repository and verify the final file is not an HTML error page or a zero-byte file.

After downloading:

```bash
ls -lh /data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf
file /data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf
```

Future model entries must include source URL, filename, quantization, size, checksum, context used, GPU layers, speed, and memory observations.
