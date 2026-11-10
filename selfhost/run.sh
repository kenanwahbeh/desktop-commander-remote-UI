#!/bin/sh
# Self-hosted mode: serve this repo's Desktop Commander MCP over Streamable HTTP
# on localhost. Publish it at https://$DC_PUBLIC_HOST/$DC_SECRET/mcp with any
# reverse proxy or tunnel pointing at http://localhost:$DC_PORT. No desktopcommander.app relay, no call cap.
cd "$(dirname "$0")"
export PATH=/opt/homebrew/bin:$PATH
[ -f .env ] || { echo "DC_SECRET=$(openssl rand -hex 24)" > .env; chmod 600 .env; }
[ -d node_modules ] || npm install --silent
. ./.env
exec node node_modules/.bin/supergateway \
  --stdio "node $(cd .. && pwd)/dist/index.js" \
  --outputTransport streamableHttp --stateful \
  --host 127.0.0.1 --port "${DC_PORT:-8765}" \
  --streamableHttpPath "/$DC_SECRET/mcp" --healthEndpoint /healthz
