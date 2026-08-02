# 8. How inference works on the Nano

The execution pipeline is:

```text
Prompt text
  -> chat template
  -> tokenizer
  -> token IDs
  -> embeddings
  -> 32 transformer layers
  -> output logits
  -> sampler
  -> next token
  -> KV cache update
  -> repeat
```

The verified model had 361.82 million parameters, 32 transformer layers, embedding width 960, 15 attention heads, 5 key-value heads, and a training context of 8192 tokens.

At context 512, the observed principal model allocations were approximately:

```text
CUDA model buffer: 256.37 MiB
CUDA KV buffer: 20.00 MiB
CUDA compute buffer: 97.88 MiB
CPU-mapped model buffer: 47.81 MiB
```

The GPU accelerates tensor and matrix operations. CPU code handles tokenization, sampling, process control, and CUDA launches. Because the Nano uses unified memory, GPU offloading does not create additional physical VRAM.
