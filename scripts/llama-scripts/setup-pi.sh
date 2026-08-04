#!/usr/bin/env bash
set -euo pipefail

# Install Pi coding agent
if ! command -v pi &>/dev/null; then
	curl -fsSL https://pi.dev/install.sh | sh
fi

# Respect PI_CODING_AGENT_DIR if set (Homebrew Pi uses it instead of ~/.pi/agent)
# PI_AGENT_DIR="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
# mkdir -p "$PI_AGENT_DIR"
ww
# # Force Pi to use home directory for config regardless of Homebrew install path
# if ! grep -qF 'PI_CODING_AGENT_DIR' "$HOME/.zshrc" 2>/dev/null; then
# 	echo "export PI_CODING_AGENT_DIR=$HOME/.pi/agent" >>"$HOME/.zshrc"
# fi
# export PI_CODING_AGENT_DIR="$PI_AGENT_DIR"

# Configure built-in llama.cpp provider via env var (persisted to shell profile)
LLAMA_URL="http://127.0.0.1:18080"
if ! grep -qF 'LLAMA_BASE_URL' "$HOME/.zshrc" 2>/dev/null; then
	echo "export LLAMA_BASE_URL=$LLAMA_URL" >>"$HOME/.zshrc"
fi
export LLAMA_BASE_URL="$LLAMA_URL"

# --- Copilot-like: plan before act (read-only exploration + clarifying questions first) ---
pi install npm:@narumitw/pi-plan-mode

# --- Copilot-like: LSP diagnostics, type-checking, linters after every edit ---
pi install npm:pi-lens

# --- Copilot-like: structured clarification questions before diving in ---
pi install npm:@juicesharp/rpiv-ask-user-question

# --- Copilot-like: persistent todo/task list overlay ---
pi install npm:@juicesharp/rpiv-todo

# --- Copilot-like: MCP servers — imports your existing VS Code MCP config automatically ---
pi install npm:pi-mcp-adapter

# --- Memory ---
pi install npm:pi-hermes-memory

# --- Web browsing / search ---
# Supports Brave, Tavily, SearXNG (self-hosted/free), Firecrawl, Exa
pi install npm:pi-web-access

# --- Browser automation (requires agent-browser on PATH: https://agent-browser.dev) ---
if ! command -v agent-browser &>/dev/null; then
	brew install agent-browser
	agent-browser install # download Chrome on first run
fi
pi install npm:pi-agent-browser-native

# --- Context window protection (critical for local models) ---
pi install npm:@hypabolic/pi-hypa

# --- llama.cpp multi-server support ---
pi install npm:pi-llama-cpp

# --- Safety: confirm before rm -rf, sudo, etc. ---
pi install npm:@gotgenes/pi-permission-system

# Write global permission config — allows read-only commands, asks for writes, denies rm -rf
PERM_CONFIG_DIR="$PI_AGENT_DIR/extensions/pi-permission-system"
mkdir -p "$PERM_CONFIG_DIR"
cp "$(dirname "$0")/.config/pi-permission-system/config.json" "$PERM_CONFIG_DIR/config.json"

# Import VS Code MCP servers into Pi (run once after install)
echo '{ "imports": ["vscode"], "mcpServers": {} }' >"$PI_AGENT_DIR/mcp.json"

echo ""
echo "Pi installed. Start with: pi"
echo "  Plan before acting: /plan <your task>"
echo "  Manage MCP servers: /mcp"
echo "  Configure llama.cpp: run ./run-router.sh first, then /login llama.cpp in Pi"
echo ""
echo "For pi-web-access, works zero-config via Exa MCP. For private search, run SearXNG:"
echo "  cd searxng && docker compose up -d"
echo "  Then add to ~/.pi/web-search.json: { \"searxngBaseUrl\": \"http://localhost:8081\" }"
