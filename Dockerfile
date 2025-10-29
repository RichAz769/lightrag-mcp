# Base image
FROM python:3.11-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

# App workdir
WORKDIR /app

# Install MCP server (LightRAG MCP) dari Git
RUN git clone https://github.com/desimpkins/daniel-lightrag-mcp.git /app/mcp \
    && pip install --no-cache-dir -e /app/mcp

# Install stdio -> SSE bridge (gateway)
RUN pip install --no-cache-dir mcp-supergateway

# Env defaults (boleh override dalam Coolify)
ENV LIGHTRAG_BASE_URL="https://lightrag.revoxwealth.com" \
    LIGHTRAG_API_KEY="" \
    LIGHTRAG_TIMEOUT="30" \
    LOG_LEVEL="INFO" \
    PORT="8010"

# Expose port SSE
EXPOSE 8010

# Start command:
# - Launch MCP server via Python module (stdio)
# - Supergateway bridge stdio -> SSE pada 0.0.0.0:$PORT
CMD supergateway \
    --command "python -m daniel_lightrag_mcp" \
    --sse-host 0.0.0.0 \
    --sse-port ${PORT}
