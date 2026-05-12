# PostgreSQL Engineering Roadmap - Quick Start Guide
## Hướng Dẫn Bắt Đầu Nhanh - Lộ Trình PostgreSQL

---

## 📋 Prerequisites / Yêu cầu

### Required Tools / Công cụ bắt buộc
- **Docker & Docker Compose** (version 20.10+)
- **PostgreSQL Client** (`psql` CLI)
- **kubectl** (for Kubernetes labs, optional)
- **Bash** or compatible shell (Git Bash on Windows)

### System Requirements / Yêu cầu hệ thống
- **RAM**: 4GB minimum (8GB recommended for Citus labs)
- **Disk**: 20GB free space
- **OS**: Linux, macOS, or Windows (WSL2 recommended)

### Installation / Cài đặt

#### macOS
```bash
brew install postgresql docker kubectl
```

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y postgresql-client docker.io kubectl
```

#### Windows (WSL2)
```bash
# Install WSL2 first, then from WSL2 terminal:
sudo apt-get update
sudo apt-get install -y postgresql-client docker.io kubectl
```

---

## 🚀 Quick Start (5 minutes)

### 1. Clone & Setup

```bash
cd /path/to/workspace
git clone <repo-url>
cd PostgreSQL
cp .env.example .env
```

### 2. Start Basic PostgreSQL Lab

```bash
cd docker/
docker compose --env-file ../.env.example up -d

# Wait for container startup (30 seconds)
sleep 30

# Go back to root directory
cd ..

# Verify connection
psql -h localhost -U engineer -d production_db -c "SELECT version();"
```

**Expected output:**
```
PostgreSQL 16.x on x86_64-pc-linux-gnu, compiled by gcc (GCC) 11.2.0, 64-bit
```

### 3. Load Sample Schema

```bash
# Load e-commerce schema
psql -h localhost -U engineer -d production_db -f sample-db/commerce_db.sql

# Verify tables
psql -h localhost -U engineer -d production_db -c "\dt"
```

### 4. Run First Lab

```bash
# Stage 1: Fundamentals
cd docs/1-fundamentals/
psql -h localhost -U engineer -d production_db -f advanced_sql.sql

# Stage 0: Data Modeling
cd ../0-data-modeling/
psql -h localhost -U engineer -d production_db -f schema_design.sql
```

### 5. Stop and Cleanup

```bash
docker compose down
# Data persists in pgdata/ volume
# To remove everything: docker compose down -v
```

---

## 🎯 Suggested Learning Paths

### Path A: Data Engineer
**Time:** 2-3 weeks | **Focus:** Schema, ETL, Warehousing

```
Stage 0: Data Modeling (2-3 days)
  → docs/0-data-modeling/
  → Practice: Design schema for your domain

Stage 1: Fundamentals (3-4 days)
  → docs/1-fundamentals/advanced_sql.sql
  → Practice: Complex queries, optimization

Stage 6: Warehousing (3-4 days)
  → docs/6-warehousing/dw_ops.sql
  → Practice: ETL, dbt workflow (etl/)

Stage 8: Modern Ecosystem (2-3 days)
  → docs/8-modern-ecosystem/vector_search_demo.sql
  → Practice: RAG pipelines
```

### Path B: Database Administrator (DBA)
**Time:** 3-4 weeks | **Focus:** HA, Operations, Reliability

```
Stage 2: Backend Integration (2-3 days)
  → docs/2-backend-integration/concurrency.sql
  → Practice: Transaction isolation, locks

Stage 3: Internals (3-4 days)
  → docs/3-internals/ + run_lab.sh
  → Practice: Query planner, vacuum, bloat

Stage 4: Operations (3-4 days)
  → docs/4-operations/ + run_lab.sh + wal_pitr_restore_lab.sh
  → Practice: Backup/recovery, failover

Stage 7: Observability (2-3 days)
  → docs/7-observability/
  → Practice: Prometheus, Grafana dashboards
```

### Path C: Distributed Systems Engineer
**Time:** 2-3 weeks | **Focus:** Scaling, Multi-node, Global

```
Stage 5: Distributed Systems (3-4 days)
  → docs/5-distributed-systems/ + run_citus_multi_node_lab.sh
  → Practice: Sharding, Citus multi-node

Stage 5: Kubernetes (2-3 days)
  → docs/5-distributed-systems/run_citus_k8s_lab.sh
  → Practice: K8s StatefulSets, operators

Stage 6: Warehousing (2-3 days)
  → docs/6-warehousing/ (multi-region patterns)
  → Practice: Global analytics infrastructure

Stage 4: Operations (1-2 days)
  → replication/, monitoring/
  → Practice: Cross-region failover
```

### Path D: Backend/Full-Stack Engineer
**Time:** 2 weeks | **Focus:** Integration, Performance

```
Stage 0-1: Fundamentals (2-3 days)
  → Learn SQL, indexing, basic optimization

Stage 2: Backend Integration (2-3 days)
  → Transactions, connection pooling, concurrency

Stage 3: Query Optimization (2-3 days)
  → EXPLAIN ANALYZE, plan reading

Stage 4: Production Ops (2-3 days)
  → Deployment patterns, monitoring

Stage 8: Modern Features (optional)
  → Vector search, time-series
```

---

## 📂 Project Structure

```
PostgreSQL/
├── docs/                          # 8 learning stages
│   ├── 0-data-modeling/          # Schema design
│   ├── 1-fundamentals/           # SQL & indexing
│   ├── 2-backend-integration/    # Transactions & locks
│   ├── 3-internals/              # MVCC, planner, vacuum
│   ├── 4-operations/             # HA, backup, recovery
│   ├── 5-distributed-systems/    # Citus, sharding, multi-region
│   ├── 6-warehousing/            # Analytics, dbt, OLAP
│   ├── 7-observability/          # Monitoring, metrics
│   └── 8-modern-ecosystem/       # Vector search, time-series
├── docker/                        # Docker Compose setup
├── kubernetes/                    # K8s manifests & Helm
├── labs/                          # Advanced lab scenarios
├── monitoring/                    # Prometheus, Grafana
├── replication/                   # Patroni, pgBouncer
├── cdc/                          # Debezium, Kafka
├── etl/                          # dbt workflows
├── vector-search/                # pgvector, RAG labs
├── warehouses/                   # Analytics schemas
├── sample-db/                    # Commerce DB schema
└── scripts/                      # Utility scripts

Lab Scripts (.sh files - 10+ total)
├── docs/3-internals/run_lab.sh
├── docs/4-operations/run_lab.sh
├── docs/4-operations/restore_lab.sh
├── docs/4-operations/wal_pitr_restore_lab.sh
├── docs/5-distributed-systems/run_lab.sh
├── docs/5-distributed-systems/run_citus_multi_node_lab.sh
└── docs/5-distributed-systems/run_citus_k8s_lab.sh
```

---

## 🔧 Common Workflows

### Run a Single-Node PostgreSQL Lab

```bash
cd docker/
docker compose up -d
psql -h localhost -U engineer -d production_db
```

### Run Multi-Node Citus Lab (Docker)

```bash
cd docs/5-distributed-systems/
docker compose -f docker-compose.citus.yml up -d
./run_citus_multi_node_lab.sh
```

### Run Multi-Node Citus Lab (Kubernetes)

```bash
# Requires: kubectl, running K8s cluster (Docker Desktop, minikube, etc)
cd docs/5-distributed-systems/
kubectl apply -f citus-k8s.yaml
./run_citus_k8s_lab.sh
```

### Test Backup & PITR

```bash
# Create base backup
mkdir -p backups/wal_archive
pg_basebackup -D backups/base_backup -F tar -z

# Run PITR restore lab
cd docs/4-operations/
./wal_pitr_restore_lab.sh
```

### Run Replication Scenario

```bash
cd replication/
# Edit patroni_config.yaml for your environment
# Deploy with Kubernetes or Docker
```

---

## 📝 Environment Configuration

Create `.env` from `.env.example`:

```bash
cp .env.example .env
```

Common variables:

```bash
# PostgreSQL
POSTGRES_VERSION=16
POSTGRES_USER=engineer
POSTGRES_PASSWORD=engineering_secret
POSTGRES_DB=production_db

# Citus (for distributed labs)
CITUS_USER=citus
CITUS_DB=citus
CITUS_VERSION=11.0

# Kubernetes
NAMESPACE=postgres
REPLICA_COUNT=3

# Backup
BACKUP_DIR=./backups
WAL_DIR=./backups/wal_archive
PITR_TARGET_TIME="2024-01-01 00:00:00"
```

---

## 🐛 Troubleshooting

### Connection Refused
```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check logs
docker logs pg_engineering_lab
```

### Port Already in Use
```bash
# Change ports in docker-compose.yml or .env
# Then restart
docker compose down
docker compose up -d
```

### Out of Memory
```bash
# Increase Docker Desktop memory allocation
# Or reduce pgbench scale factor in .env
PGBENCH_SCALE=10  # Instead of 100
```

For more troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 📚 Next Steps

1. **Read**: [ARCHITECTURE.md](ARCHITECTURE.md) for system design overview
2. **Choose**: A learning path (A/B/C/D above)
3. **Practice**: Run labs corresponding to your path
4. **Reference**: Each stage has detailed README with objectives
5. **Contribute**: See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines

---

## 🆘 Getting Help

- **Issues**: Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Labs**: Each stage has `README.md` with lab instructions
- **Examples**: `sample-db/`, `vector-search/`, `warehouses/` contain working schemas
- **Scripts**: Lab automation scripts in each `docs/N-*/` directory

---

**Happy learning! 🚀**

For detailed documentation, start with [docs/README.md](docs/README.md)
