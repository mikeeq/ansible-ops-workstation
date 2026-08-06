#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LLAMA_DIR="${ROOT_DIR}/llama.cpp"

# Required for RX 7900 XTX (gfx1100) ROCm compatibility
export HSA_OVERRIDE_GFX_VERSION=11.0.0

# exec "${LLAMA_DIR}/build/bin/llama-server" \
# 	-hf unsloth/Qwen3.6-35B-A3B-GGUF:Q4_K_M \
# 	--spec-default \
# 	-ngl 99 \
# 	-c 65536 \
# 	-ctk q8_0 -ctv q8_0 \
# 	-fa \
# 	--temp 0.6 --top-k 20 --top-p 0.95 --repeat-penalty 1.0 \
# 	--presence-penalty 0.0 \
# 	--chat-template-kwargs '{"preserve_thinking": true}' \
# 	-np 1 \
# 	--jinja \
# 	--host 0.0.0.0 --port 18081

# GPU: 0
#     PROCESS_INFO:
#         NAME: /home/mikee/git/mikee/ansible-ops-workstation/scripts/llama-scripts/llama.cpp/build/bin/llama-server
#         PID: 336704
#         MEMORY_USAGE:
#             GTT_MEM: 2.0 MB
#             CPU_MEM: 0.0 B
#             VRAM_MEM: 21.8 GB
#         MEM_USAGE: 22.5 GB
#         USAGE:
#             GFX: 0 ns
#             ENC: 0 ns
#         CU_OCCUPANCY: N/A

# free ~2 layers to GPU to make room, put 2 on CPU
exec "${LLAMA_DIR}/build/bin/llama-server" \
	-hf unsloth/Qwen3.6-35B-A3B-GGUF:Q4_K_M \
	--spec-default \
	-c 131072 -ctk q4_0 -ctv q4_0 -ngl 92 \
	--temp 0.6 --top-k 20 --top-p 0.95 --repeat-penalty 1.0 \
	--presence-penalty 0.0 \
	--chat-template-kwargs '{"preserve_thinking": true}' \
	-np 1 \
	--jinja \
	--host 0.0.0.0 --port 18081
