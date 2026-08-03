#!/usr/bin/env bash

set -euo pipefail

exec ./llama.cpp/build/bin/llama-server \
	-hf unsloth/Qwen3.6-27B-GGUF:Q4_K_M \
	--spec-default \
	--no-mmproj \
	--fit on \
	-np 1 \
	-c 65536 \
	--cache-ram 4096 -ctxcp 2 \
	--jinja \
	--temp 0.6 \
	--top-p 0.95 \
	--top-k 20 \
	--min-p 0.0 \
	--presence-penalty 0.0 \
	--repeat-penalty 1.0 \
	--reasoning on \
	--chat-template-kwargs '{"preserve_thinking": true}' \
	--host 0.0.0.0 \
	--port 18080
