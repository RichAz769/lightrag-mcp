#!/usr/bin/env bash
set -e

# Start Supergateway (stdio -> SSE) dan spawn MCP Python module
# SSE endpoint: /sse  |  message endpoint: /message  |  health: /health
# Nota: npx akan auto-install supergateway (tanpa perlu global install)
exec npx -y supergateway \
  --stdio "python3 -m daniel_lightrag_mcp" \
  --port "${PORT}" \
  --baseUrl "http://0.0.0.0:${PORT}" \
  --ssePath "/sse" \
  --messagePath "/message" \
  --healthEndpoint "/health" \
  --logLevel info
