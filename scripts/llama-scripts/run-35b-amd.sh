#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LLAMA_DIR="${ROOT_DIR}/llama.cpp"

# Required for RX 7900 XTX (gfx1100) ROCm compatibility
export HSA_OVERRIDE_GFX_VERSION=11.0.0

exec "${LLAMA_DIR}/build/bin/llama-server" \
	-hf unsloth/Qwen3.6-35B-A3B-GGUF:Q4_K_M \
	--spec-default \
	-ngl 99 \
	-c 131072 \
	--temp 0.6 --top-k 20 --top-p 0.95 --repeat-penalty 1.0 \
	--presence-penalty 0.0 \
	--chat-template-kwargs '{"preserve_thinking": true}' \
	-np 1 \
	--jinja \
	--host 0.0.0.0 --port 18080
