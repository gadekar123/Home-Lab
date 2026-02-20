#!/usr/bin/env bash

set -e

echo "🚀 Homelab Bootstrap Starting..."

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MONITORING_DIR="$BASE_DIR/monitoring"

echo "📁 Creating required directories..."

mkdir -p "$MONITORING_DIR/grafana-data"
mkdir -p "$MONITORING_DIR/prometheus-data"
mkdir -p "$MONITORING_DIR/gotify-data"
mkdir -p "$MONITORING_DIR/alerts"

echo "🔐 Setting correct permissions..."

# Grafana runs as UID 472
sudo chown -R 472:472 "$MONITORING_DIR/grafana-data"

# Prometheus runs as UID 65534 (nobody)
sudo chown -R 65534:65534 "$MONITORING_DIR/prometheus-data"

# Gotify runs as nobody internally
sudo chown -R 65534:65534 "$MONITORING_DIR/gotify-data"

echo "🌐 Checking Docker network..."

if ! docker network inspect media_net >/dev/null 2>&1; then
    ech
o "➕ Creating Docker network: media_net"
    docker network create media_net
else
    echo "✅ Docker network media_net already exists"
fi

echo "🐳 Verifying Docker installation..."

if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Docker not installed. Please install Docker first."
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    echo "❌ Docker Compose plugin not found."
    exit 1
fi

echo ""
echo "✅ Bootstrap completed successfully!"
echo ""
echo "Next steps:"
echo "  cd monitoring"
echo "  docker compose up -d"
echo ""
