# Kita perlukan Node untuk npx supergateway + Python untuk MCP
FROM node:20-bookworm

# Pasang Python + alat asas
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-venv python3-pip python3-dev build-essential git ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Sediakan virtualenv supaya tak trigger PEP 668
RUN python3 -m venv /opt/venv
# Upgrade pip toolchain dalam venv
RUN /opt/venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel

# Clone & install MCP (editable optional; kalau nak elak editable, boleh buang -e)
RUN git clone https://github.com/desimpkins/daniel-lightrag-mcp.git /app/mcp \
 && /opt/venv/bin/pip install --no-cache-dir -e /app/mcp

# Salin entrypoint dan beri permission
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# ENV (override dalam Coolify; jangan letak secrets hardcode di Dockerfile)
ENV LIGHTRAG_BASE_URL="https://lightrag.revoxwealth.com" \
    LIGHTRAG_API_KEY="" \
    LIGHTRAG_TIMEOUT="30" \
    LOG_LEVEL="INFO" \
    PORT="8010" \
    PATH="/opt/venv/bin:${PATH}"

EXPOSE 8010

# Guna JSON-form supaya signal handling elok
CMD ["/app/entrypoint.sh"]
