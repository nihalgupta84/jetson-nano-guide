#!/usr/bin/env bash
set -euo pipefail

DEST=/data/llama.cpp
COMMIT=23106f94e

if [[ ! -d "$DEST/.git" ]]; then
  git clone https://github.com/ggml-org/llama.cpp.git "$DEST"
fi

cd "$DEST"
git fetch --tags --force
git checkout "$COMMIT"
if ! git show-ref --verify --quiet refs/heads/jetson-nano-cuda; then
  git checkout -b jetson-nano-cuda
else
  git checkout jetson-nano-cuda
  git reset --hard "$COMMIT"
fi

git log -1 --oneline
