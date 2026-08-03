#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LLAMA_DIR="${ROOT_DIR}/llama.cpp"

# MAIN="$HOME/Library/Application Support/io.datasette.llm/gguf/models/Qwen3.6-35B-A3B-MXFP4_MOE.gguf"
# ls "${MAIN}"

# exec "${LLAMA_DIR}/build/bin/llama-server" \
#   -m "$MAIN" \
#   --spec-default \
#   -c 262144 \
#   --temp 0.6 --top-k 20 --top-p 0.95 --repeat-penalty 1.0 \
#   --presence-penalty 0.0 \
#   --chat-template-kwargs '{"preserve_thinking": true}' \
#   --parallel 1 \
#   --jinja \
#   --host 0.0.0.0 --port 8000

exec "${LLAMA_DIR}/build/bin/llama-server" \
	-hf unsloth/Qwen3.6-35B-A3B-GGUF:MXFP4_MOE \
	--spec-default \
	--fit on \
	--no-mmap \
	--temp 0.6 --top-k 20 --top-p 0.95 --repeat-penalty 1.0 \
	--presence-penalty 0.0 \
	--chat-template-kwargs '{"preserve_thinking": true}' \
	-np 1 \
	--jinja \
	--host 0.0.0.0 --port 18080
