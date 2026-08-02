#!/usr/bin/env bash
set -euo pipefail

BIN=/data/llama.cpp/build-nano/bin/llama-cli
[[ -x "$BIN" ]] || { echo "Missing $BIN" >&2; exit 1; }

"$BIN" --version

echo '== Linked CUDA libraries =='
ldd "$BIN" | grep -Ei 'ggml-cuda|cuda|cublas'
