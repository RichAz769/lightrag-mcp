#!/usr/bin/env bash
set -e

# Pastikan venv ada pip & module
python --version
pip --version
python -c "import daniel_lightrag_mcp; print('MCP module OK')" || exit 1

# Jalankan Supergateway (stdio -> SSE) dan spawn MCP dari venv
# Endpoint:
#   SSE:      /sse
#   Message:  /message
#   Health:   /health
exec npx -y supergateway \
  --stdio "python -m daniel_lightrag_mcp" \
  --port "${PORT}" \
  --baseUrl "http://0.0.0.0:${PORT}" \
  --ssePath "/sse" \
  --messagePath "/message" \
  --healthEndpoint "/health" \
  --logLevel info
