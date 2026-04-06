#!/bin/bash
# Run this once before first docker compose up -d
# Sets correct ownership on data directories for each service

mkdir -p data/prometheus data/loki data/grafana
chown -R 65534:65534 data/prometheus
chown -R 10001:10001 data/loki
chown -R 472:472 data/grafana

echo "Data directories ready. Run: docker compose up -d"
