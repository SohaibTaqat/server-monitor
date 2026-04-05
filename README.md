# Linux Server Monitoring Stack

A simple hardware monitoring stack for Ubuntu servers using Grafana Alloy, Prometheus, Loki, and Grafana.

## What You Get

- CPU usage (per core)
- Memory and swap usage
- Disk I/O and space
- Network traffic
- System load
- System logs (journald + file logs)

## Requirements

- Ubuntu 20.04+ (or other modern Linux with systemd)
- Docker and Docker Compose

## Setup

```bash
git clone https://github.com/SohaibTaqat/server-monitor.git
cd server-monitor
docker compose up -d
```

## Access

| Service | URL | Purpose |
|---------|-----|---------|
| Grafana | http://localhost:3000 | Dashboards and logs |
| Alloy | http://localhost:12345 | Pipeline debugging |
| Prometheus | http://localhost:9090 | Raw metrics queries |

No login required - anonymous admin is enabled.

## Import Dashboard

1. Open Grafana at http://localhost:3000
2. Go to **Dashboards** > **Import**
3. Enter ID `1860` and click **Load**
4. Select **Prometheus** as the data source
5. Click **Import**

## View Logs

Open http://localhost:3000/a/grafana-lokiexplore-app to explore system logs.

## Commands

```bash
# Start the stack
docker compose up -d

# Stop the stack
docker compose down

# View logs
docker compose logs -f

# Restart after config changes
docker compose restart alloy
```

## Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Container definitions |
| `config.alloy` | Metrics and log collection config |
| `prom-config.yaml` | Prometheus settings |
| `loki-config.yaml` | Loki settings |

## Customization

Edit `config.alloy` to:
- Add/remove metric collectors
- Change scrape intervals
- Modify log collection paths

After changes, run `docker compose restart alloy`.
