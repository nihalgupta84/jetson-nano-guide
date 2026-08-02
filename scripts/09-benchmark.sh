#!/usr/bin/env bash
set -euo pipefail

BENCH=/data/llama.cpp/build-nano/bin/llama-bench
MODEL=${1:-/data/models/SmolLM2-360M-Instruct-Q4_K_M.gguf}
OUT=${2:-/data/jetson-nano-guide/benchmarks/benchmark-$(date +%Y%m%d-%H%M%S).txt}

mkdir -p "$(dirname "$OUT")"
{
  echo '== Platform =='
  date --iso-8601=seconds
  tr -d '\0' < /proc/device-tree/model; echo
  free -h
  echo
  echo '== GPU offload =='
  "$BENCH" -m "$MODEL" -ngl 99 -t 4 -p 128 -n 64
  echo
  echo '== CPU only =='
  "$BENCH" -m "$MODEL" -ngl 0 -t 4 -p 128 -n 64
} | tee "$OUT"
