#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
LOGS_DIR="$ROOT/.logs"
mkdir -p "$LOGS_DIR"

cleanup() {
  echo ""
  echo "Parando tudo..."
  kill "$FRONT_PID" 2>/dev/null
  docker compose -f "$ROOT/backend/docker-compose.yml" down
  echo "Pronto."
}
trap cleanup EXIT INT TERM

# Backend
echo "Subindo backend (Postgres + Directus)..."
docker compose -f "$ROOT/backend/docker-compose.yml" up -d

echo "Aguardando Directus ficar pronto..."
until curl -sf http://localhost:8055/server/ping > /dev/null 2>&1; do
  sleep 2
done
echo "Directus OK: http://localhost:8055"

# Logs do Directus em background
docker compose -f "$ROOT/backend/docker-compose.yml" logs -f directus > "$LOGS_DIR/directus.log" 2>&1 &

# Frontend
echo "Subindo frontend (Astro)..."
cd "$ROOT/frontend"
bun run dev 2>&1 | tee "$LOGS_DIR/astro.log" &
FRONT_PID=$!

echo ""
echo "==========================================="
echo "  Backend:  http://localhost:8055"
echo "  Frontend: http://localhost:4321"
echo ""
echo "  Logs:"
echo "    tail -f .logs/directus.log"
echo "    tail -f .logs/astro.log"
echo ""
echo "  Ctrl+C para parar tudo"
echo "==========================================="
echo ""

wait "$FRONT_PID"
