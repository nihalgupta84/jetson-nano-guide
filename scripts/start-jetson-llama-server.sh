#!/usr/bin/env bash
set -euo pipefail

CONFIG=/etc/jetson-ai/llama-server.env

if [[ ! -r "$CONFIG" ]]; then
    echo "Missing configuration: $CONFIG" >&2
    exit 1
fi

# shellcheck disable=SC1090
source "$CONFIG"

required_vars=(
    MODEL_NAME MODEL_ALIAS MODEL_PATH HOST PORT
    CTX_SIZE THREADS GPU_LAYERS MAX_TOKENS
)

for variable in "${required_vars[@]}"; do
    if [[ -z "${!variable:-}" ]]; then
        echo "Missing variable in $CONFIG: $variable" >&2
        exit 1
    fi
done

if [[ ! -f "$MODEL_PATH" ]]; then
    echo "Model does not exist: $MODEL_PATH" >&2
    exit 1
fi

echo "Starting model: $MODEL_NAME"
echo "Display alias: $MODEL_ALIAS"
echo "Model path: $MODEL_PATH"

exec /data/llama.cpp/build-nano/bin/llama-server \
    -m "$MODEL_PATH" \
    --alias "$MODEL_ALIAS" \
    -ngl "$GPU_LAYERS" \
    -c "$CTX_SIZE" \
    -t "$THREADS" \
    -n "$MAX_TOKENS" \
    --host "$HOST" \
    --port "$PORT"
