#!/usr/bin/env bash
# Sends a minimal request every 4 minutes to prevent the router from sleeping the model.
set -euo pipefail

PORT="${1:-18080}"
INTERVAL=240  # seconds — router typically sleeps models after 5+ minutes of inactivity

echo "Keeping llama-server at port $PORT alive (ping every ${INTERVAL}s). Ctrl+C to stop."

while true; do
    curl -s -o /dev/null \
        "http://127.0.0.1:${PORT}/health" || \
    echo "$(date): server unreachable, retrying..."
    sleep "$INTERVAL"
done
