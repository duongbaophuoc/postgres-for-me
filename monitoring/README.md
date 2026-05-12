# monitoring/

This folder contains PostgreSQL monitoring and alerting assets for Prometheus-based observability.

## What is included

- `prometheus_alerts.yml` - Prometheus alert rules for replication lag, transaction ID wraparound, and cache hit ratio.
- `REQUIREMENTS.md` - required exporter and Prometheus environment details.

## Purpose

Use this folder to integrate PostgreSQL observability into Prometheus, practice metric-driven alerting, and validate monitoring rules.

## Quick start

1. Run a PostgreSQL exporter such as `postgres_exporter` and ensure Prometheus can scrape it.
2. Add the alert rules file to your Prometheus configuration:

```yaml
rule_files:
  - '/etc/prometheus/prometheus_alerts.yml'
```

3. Reload Prometheus:

```powershell
curl -X POST http://localhost:9090/-/reload
```
```

4. Example PostgreSQL scrape job:

```yaml
scrape_configs:
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres:9187']
```

5. Confirm the rules are loaded in Prometheus at `http://localhost:9090/rules`.

## Alert rule overview

- `PostgresReplicationLag` monitors `pg_replication_lag_seconds`.
- `PostgresTransactionIDWraparound` warns when `pg_database_wraparound_days` falls below 14 days.
- `PostgresLowCacheHitRatio` warns when buffer cache hit ratio drops below 95%.

## Validate a rule

Run the following Prometheus query in the UI:

```text
pg_replication_lag_seconds > 30
```

## Notes

- Ensure the PostgreSQL exporter exposes `pg_stat_replication`, `pg_database`, and buffer statistics.
- Use Grafana to build dashboards from these metrics after the rules are active.
- Review `REQUIREMENTS.md` before deploying the monitoring stack.
