#!/usr/bin/env bash
set -euo pipefail

BIN=/data/llama.cpp/build-nano/bin/llama-cli
MODEL=/data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf

[[ -x "$BIN" ]] || { echo "Missing llama-cli: $BIN" >&2; exit 1; }
[[ -s "$MODEL" ]] || { echo "Missing model: $MODEL" >&2; exit 1; }

exec "$BIN" \
  -m "$MODEL" \
  -ngl 99 \
  -c 512 \
  -t 4 \
  -n 128
