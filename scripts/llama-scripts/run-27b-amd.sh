#!/usr/bin/env bash
set -euo pipefail

# Required for RX 7900 XTX (gfx1100) ROCm compatibility
export HSA_OVERRIDE_GFX_VERSION=11.0.0

exec ./llama.cpp/build/bin/llama-server \
	-hf unsloth/Qwen3.6-27B-GGUF:Q5_K_M \
	--spec-default \
	--no-mmproj \
	-ngl 99 \
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
	--port 18081

# NAME: /home/mikee/git/mikee/ansible-ops-workstation/scripts/llama-scripts/llama.cpp/build/bin/llama-server
# PID: 332994
# MEMORY_USAGE:
#     GTT_MEM: 2.0 MB
#     CPU_MEM: 0.0 B
#     VRAM_MEM: 21.3 GB
