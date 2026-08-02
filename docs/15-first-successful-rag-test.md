# First Successful RAG Test

## Status

Verified on 2026-08-02.

The Jetson Nano successfully completed an end-to-end Retrieval-Augmented Generation workflow through Open WebUI using the local `llama-server` backend.

## Verified flow

```text
PDF upload
  -> text extraction
  -> chunking
  -> embeddings with all-MiniLM-L6-v2
  -> vector storage
  -> semantic retrieval
  -> relevant context sent to Qwen2.5-0.5B-Instruct
  -> grounded answer in Open WebUI
```

## Working components

- Open WebUI knowledge base creation
- PDF upload and indexing
- Local embedding generation
- Vector retrieval
- Retrieval-backed chat answers
- Qwen2.5-0.5B-Instruct served by CUDA-enabled `llama.cpp`
- Access through `https://ai.nihalgupta.me`

## Resource considerations

The first successful RAG test was completed on a 4 GB Jetson Nano while the full stack was active:

- `llama-server`
- Open WebUI
- `cloudflared`
- Docker
- `all-MiniLM-L6-v2` embedding model

The last verified baseline before the RAG test showed substantial memory pressure:

```text
Available RAM: approximately 558 MiB
Swap used: approximately 801 MiB
Root filesystem: 89% used
/data filesystem: 73% used
```

Because of these limits, scale the knowledge base gradually. Start with one short paper, verify indexing and retrieval, then add documents in small batches.

## Recommended validation questions

Use questions whose answers can be checked directly in the uploaded document:

1. What is the exact paper title?
2. Who are the authors?
3. Which dataset was used?
4. What optimizer was used?
5. What are the main contributions?
6. Summarize a named section.

This helps distinguish genuine document retrieval from unsupported model generation.

## Current compatibility settings

For the pinned `llama.cpp` backend and small Qwen model:

```text
Function calling: Legacy
Builtin Tools: Off
Web Search: Off
Code Interpreter: Off
Image Generation: Off
File Upload: On
File Context: On
Citations: Optional
```

These settings avoid the `Cannot use tools with stream` error while preserving document context and normal streaming chat.

## Next optimization stage

Before loading a large paper collection:

1. Measure RAM, swap, indexing time, and query latency for one document.
2. Tune chunk size and overlap for research papers.
3. Compare the default embedding model with a smaller low-memory alternative.
4. Confirm all Open WebUI data remains on `/data`.
5. Add documents in controlled batches and rerun the stack health check after each batch.
