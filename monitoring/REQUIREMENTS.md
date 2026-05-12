# Monitoring & Observability Engineering Requirements
## Yêu cầu Kỹ thuật Giám sát & Khả năng quan sát

### 🎯 Objective / Mục tiêu
- Implement full-stack observability for PostgreSQL using Prometheus and Grafana.
- Triển khai khả năng giám sát toàn diện cho PostgreSQL.

### 🛠️ Technical Stack / Công nghệ
- **postgres_exporter**: Scraping metrics from `pg_stat_*` views.
- **Prometheus**: Time-series database for metrics.
- **Grafana**: Dashboarding and visualization.

---

### 🚨 Critical Alerts (Prometheus Rules)
File: `postgres_alerts.yml`

```yaml
groups:
  - name: postgres_alerts
    rules:
      - alert: PostgreSqlHighReplicationLag
        expr: pg_replication_lag_seconds > 60
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Replication lag is too high on {{ $labels.instance }}"

      - alert: PostgreSqlTransactionWraparoundRisk
        expr: pg_database_wraparound_days < 10
        for: 1h
        labels:
          severity: emergency
        annotations:
          summary: "Transaction ID wraparound risk in 10 days!"
```

### 📊 Key Dashboards
- Transaction Throughput (TPS).
- Cache Hit Ratio (Should be > 99%).
- Connection Usage (Bouncer vs Postgres).
