# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker Compose stack for monitoring Ubuntu servers: Grafana Alloy collects host metrics and logs, sends metrics to Prometheus and logs to Loki, with Grafana as the dashboard frontend.

## Commands

```bash
docker compose up -d          # Start the stack
docker compose down            # Stop the stack
docker compose restart alloy   # Restart Alloy after config changes
docker compose logs -f         # Tail all logs
```

There is no build step, linter, or test suite — this is a configuration-only repo.

## Architecture

```
Host OS (Ubuntu)
  │
  ├── Alloy (grafana/alloy) — collects metrics + logs
  │     ├── prometheus.exporter.unix → scrape → prometheus.remote_write → Prometheus:9090
  │     ├── loki.source.journal ──→ loki.write → Loki:3100
  │     └── loki.source.file ────→ loki.write → Loki:3100
  │
  ├── Prometheus (:9090) — metrics storage, receives remote writes from Alloy
  ├── Loki (:3100) — log storage
  └── Grafana (:3000) — dashboards (datasources auto-provisioned via entrypoint script)
```

## Key Config Relationships

- **docker-compose.yml** — defines all four services; Alloy runs `privileged: true` with `pid: host` and mounts the host root at `/host:ro,rslave` so node_exporter collectors can read host-level metrics from inside the container.
- **config.alloy** — Alloy pipeline config (River syntax). `rootfs = "/host"` tells the unix exporter to read from the mounted host filesystem. Metrics go to `prometheus:9090`, logs go to `loki:3100`.
- **prom-config.yaml** — minimal Prometheus config; Alloy pushes via remote write, so no scrape targets are defined here.
- **loki-config.yaml** — single-instance Loki with TSDB + filesystem storage.
- Grafana datasources (Prometheus + Loki) are provisioned inline in the Grafana service's entrypoint script within docker-compose.yml, not in a separate file.

## Deployment Notes

- Target: Ubuntu 20.04+ with Docker installed
- Image versions are parameterized via environment variables (e.g. `GRAFANA_ALLOY_VERSION`) with defaults in docker-compose.yml
- Grafana has anonymous admin enabled (no login) — suitable for internal/trusted networks only
- Recommended Grafana dashboard: import ID `1860` (Node Exporter Full)
