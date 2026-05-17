# scripts/ — Utility Scripts & Tools
# scripts/ — Script Tiện Ích & Công Cụ

Utility scripts and tools for PostgreSQL operations, health checks, and diagnostics.

---

## Files / Tập Tin

| File | Type | Description |
|------|------|-------------|
| `health_check.py` | Python | PostgreSQL cluster health monitor |
| `check_bloat.sql` | SQL | Table & index bloat detection query |

---

## health_check.py

A Python script that connects to a PostgreSQL cluster and runs a series of health diagnostics.

### What It Checks / Kiểm Tra

| Check | Description |
|-------|-------------|
| Connection | Database reachability |
| Replication lag | Primary → replica delay |
| Bloat | Table and index bloat percentage |
| Long transactions | Transactions running > threshold |
| Lock waits | Blocking sessions |
| Autovacuum | Tables needing urgent vacuum |
| Disk usage | Database size |

### Requirements / Yêu Cầu

```bash
# Python 3.8+
pip install psycopg2-binary
```

### Usage / Sử Dụng

```bash
# Basic usage (localhost)
python health_check.py

# With connection parameters
python health_check.py \
  --host localhost \
  --port 5432 \
  --user postgres \
  --dbname postgres

# With environment variables
PGHOST=localhost PGUSER=postgres python health_check.py
```

### Output Example / Ví Dụ Output

```
[OK]  Connection: localhost:5432 (postgres)
[OK]  Replication lag: 0.12s
[WARN] Bloat detected: orders table 23% bloat
[OK]  No long transactions (>5min)
[OK]  No lock waits
[OK]  Autovacuum: all tables healthy
[OK]  Database size: 4.2 GB
```

---

## check_bloat.sql

SQL query to identify tables and indexes with excessive bloat (dead tuples).

### Usage / Sử Dụng

```bash
# Run against your database
psql -U postgres -d your_db -f check_bloat.sql

# Or copy-paste into psql / pgAdmin
```

### When to Use / Khi Nào Dùng

- After high-volume DELETE or UPDATE operations
- When VACUUM is not keeping up
- During Stage 3 (Internals) lab practice
- As part of weekly DBA health checks

---

## Related Stages / Giai Doan Lien Quan

- **Stage 3** — Internals: MVCC, bloat, autovacuum
- **Stage 4** — Production Ops: health monitoring
- **Stage 7** — Observability: integrate with Prometheus/Grafana

---

> **Note:** Do not commit Python `.pyc` files or `__pycache__/` directories. These are excluded by `.gitignore`.