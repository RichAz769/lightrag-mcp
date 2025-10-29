# Base dengan Node + Debian (untuk npx supergateway)
FROM node:20-bookworm

# Pasang Python 3 + pip + git
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv git ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone & install MCP server (LightRAG MCP)
RUN git clone https://github.com/desimpkins/daniel-lightrag-mcp.git /app/mcp \
 && pip3 install --no-cache-dir -e /app/mcp

# Salin entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# ENV (override dalam Coolify)
ENV LIGHTRAG_BASE_URL="https://lightrag.revoxwealth.com" \
    LIGHTRAG_API_KEY="" \
    LIGHTRAG_TIMEOUT="30" \
    LOG_LEVEL="INFO" \
    PORT="8010"

EXPOSE 8010

# Guna JSON-form CMD untuk signal handling yang betul
CMD ["/app/entrypoint.sh"]
