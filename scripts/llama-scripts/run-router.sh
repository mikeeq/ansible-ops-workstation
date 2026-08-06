#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LLAMA_DIR="${ROOT_DIR}/llama.cpp"

# Models are stored by -hf downloads in $LLAMA_CACHE (default: ~/Library/Caches/llama.cpp on macOS)
exec "${LLAMA_DIR}/build/bin/llama-server" \
	--models-dir "${LLAMA_CACHE:-$HOME/.cache/huggingface/hub}" \
	--no-models-autoload \
	--spec-default \
	--fit on \
	--load-mode none \
	-np 1 \
	--jinja \
	--temp 0.6 --top-k 20 --top-p 0.95 --repeat-penalty 1.0 \
	--presence-penalty 0.0 \
	--chat-template-kwargs '{"preserve_thinking": true}' \
	--host 0.0.0.0 \
	--port 18080

# exec "${LLAMA_DIR}/build/bin/llama-server" \
# 	--models-dir "${LLAMA_CACHE:-$HOME/.cache/huggingface/hub}" \
# 	--models-preset "${ROOT_DIR}/models-preset.ini" \
# 	--host 0.0.0.0 \
# 	--port 18080

# /login
# /llama
# /model

# Current agent requested bash command 'hypa -c "ls -la ~/git/mikee/ansible-ops-workstation/scripts/llama-scripts/"' (matched '*'). Allow
# this command?
