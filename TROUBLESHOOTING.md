# Troubleshooting Guide
## Hướng Dẫn Khắc Phục Sự Cố

---

## 🚨 Common Issues & Solutions

### Docker & Container Issues

#### Issue: "docker: command not found"
**Cause:** Docker not installed or not in PATH

**Solution:**
```bash
# macOS
brew install docker

# Ubuntu
sudo apt-get install -y docker.io

# Verify installation
docker --version
```

#### Issue: "Cannot connect to Docker daemon"
**Cause:** Docker daemon not running or user permissions

**Solution:**
```bash
# Start Docker daemon
sudo systemctl start docker  # Linux
open -a Docker              # macOS

# Add user to docker group (Linux)
sudo usermod -aG docker $USER
newgrp docker
```

#### Issue: "Port 5432 already in use"
**Cause:** Another PostgreSQL instance running or port conflict

**Solution:**
```bash
# Find process using port 5432
lsof -i :5432  # macOS/Linux
Get-NetTCPConnection -LocalPort 5432  # Windows

# Kill the process or change port in .env
POSTGRES_PORT=5433

# Restart containers
docker compose down
docker compose up -d
```

#### Issue: "docker compose: command not found"
**Cause:** Docker Compose v2 not installed or outdated

**Solution:**
```bash
# Install Docker Compose v2
docker-compose --version  # Check if v1 exists

# Upgrade to v2
pip install --upgrade docker-compose

# Or use Docker Compose as plugin
docker compose --version
```

---

### PostgreSQL Connection Issues

#### Issue: "psql: could not translate host name"
**Cause:** PostgreSQL service not running or hostname incorrect

**Solution:**
```bash
# Check if container is running
docker ps | grep postgres

# Check container status
docker compose logs postgres

# Restart container
docker compose restart postgres

# Verify connection
psql -h localhost -U engineer -d production_db -c "SELECT 1;"
```

#### Issue: "password authentication failed"
**Cause:** Wrong credentials

**Solution:**
```bash
# Check credentials in .env file
cat .env | grep POSTGRES_

# Use correct credentials
psql -h localhost -U engineer -d production_db \
     -w -c "SELECT 1;"

# Reset password (if in container)
docker exec pg_engineering_lab psql -U engineer -d production_db \
     -c "ALTER USER engineer WITH PASSWORD 'new_password';"
```

#### Issue: "FATAL: Ident authentication failed for user"
**Cause:** pg_hba.conf authentication method issue

**Solution:**
```bash
# From container, check pg_hba.conf
docker exec pg_engineering_lab cat /var/lib/postgresql/data/pg_hba.conf

# Use TCP connection instead of Unix socket
psql -h localhost -U engineer -d production_db
```

#### Issue: "connection refused"
**Cause:** PostgreSQL service not running or bind_address incorrect

**Solution:**
```bash
# Check if container is running
docker compose ps

# Check logs for errors
docker compose logs postgres

# Verify port mapping
docker port pg_engineering_lab

# Ensure bind_address is 0.0.0.0 (for Docker)
docker inspect pg_engineering_lab | grep "127.0.0.1\|0.0.0.0"
```

---

### Lab Script Issues

#### Issue: "run_lab.sh: permission denied"
**Cause:** Script not executable

**Solution:**
```bash
# On Linux/macOS
chmod +x docs/3-internals/run_lab.sh
./docs/3-internals/run_lab.sh

# On Windows (PowerShell)
# Scripts should work directly, or use bash
bash docs/3-internals/run_lab.sh
```

#### Issue: Lab script hangs/times out
**Cause:** Database not ready, resource constraints, or slow queries

**Solution:**
```bash
# Kill the hanging script (Ctrl+C)

# Check resource usage
docker stats pg_engineering_lab

# Increase Docker memory allocation
# Docker Desktop → Preferences → Resources → Memory: 8GB

# Reduce dataset size in lab scripts (edit SCALE, DURATION)

# Run with timeout
timeout 300 ./docs/3-internals/run_lab.sh
```

#### Issue: "Command 'pg_basebackup' not found"
**Cause:** PostgreSQL client tools not installed

**Solution:**
```bash
# Install PostgreSQL client
brew install postgresql          # macOS
sudo apt-get install -y postgresql-client  # Ubuntu

# Or run from within container
docker exec pg_engineering_lab pg_basebackup -D /tmp/backup -F tar -z
```

---

### Citus Multi-Node Lab Issues

#### Issue: "Citus multi-node lab fails to register workers"
**Cause:** Workers not ready or network issues

**Solution:**
```bash
# Check all containers are running
docker ps | grep citus

# Check worker connectivity
docker exec citus_coordinator psql -U citus -d citus \
     -c "SELECT * FROM citus_nodes;"

# Check worker logs
docker logs citus_worker1
docker logs citus_worker2

# Restart all containers
docker compose -f docs/5-distributed-systems/docker-compose.citus.yml down
docker compose -f docs/5-distributed-systems/docker-compose.citus.yml up -d
```

#### Issue: "Worker node registration fails with 'could not connect'"
**Cause:** Worker DNS/hostname resolution or firewall

**Solution:**
```bash
# Check worker service name matches docker-compose
# Edit docker-compose.citus.yml: worker1, worker2 must match

# Test connectivity from coordinator
docker exec citus_coordinator psql -h worker1 -U citus -d citus -c "SELECT 1;"

# Verify network
docker network inspect docs_citus-net
```

---

### Kubernetes Issues

#### Issue: "kubectl: command not found"
**Cause:** kubectl not installed

**Solution:**
```bash
# macOS
brew install kubectl

# Ubuntu
sudo apt-get install -y kubectl

# Or download binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

#### Issue: "No resources found in namespace"
**Cause:** K8s cluster not accessible or wrong context

**Solution:**
```bash
# Check cluster connection
kubectl cluster-info

# List available contexts
kubectl config get-contexts

# Switch context
kubectl config use-context docker-desktop

# Check pods in namespace
kubectl get pods -n citus
kubectl describe pod -n citus <pod-name>
```

#### Issue: "Pod stuck in Pending state"
**Cause:** Insufficient resources or PVC issues

**Solution:**
```bash
# Check pod status
kubectl describe pod -n citus <pod-name>

# Check PVC status
kubectl get pvc -n citus
kubectl describe pvc -n citus <pvc-name>

# Check node resources
kubectl top nodes
kubectl describe node <node-name>

# Delete and redeploy
kubectl delete -f kubernetes/citus-k8s.yaml
kubectl apply -f kubernetes/citus-k8s.yaml
```

---

### Backup & Recovery Issues

#### Issue: "No base backup tar found in backups/"
**Cause:** Backup directory not created or pg_basebackup not run

**Solution:**
```bash
# Create backup manually
mkdir -p backups/wal_archive
pg_basebackup -h localhost -U engineer -D backups/base_backup \
     -F tar -z -P

# Verify backup created
ls -lah backups/
tar -tzf backups/base_backup.tar.gz | head
```

#### Issue: "PITR restore fails with 'recovery target invalid'"
**Cause:** Target time before earliest WAL segment or after latest

**Solution:**
```bash
# Check available WAL segments
ls -la backups/wal_archive/

# Set realistic target time
export PITR_TARGET_TIME="2024-01-01 12:00:00"
# Must be between: base backup time and latest WAL

# Verify WAL segment format
ls backups/wal_archive/ | head
# Should look like: 000000010000000000000001
```

#### Issue: "Recovery instance won't start after restore"
**Cause:** Corrupted data directory or permissions

**Solution:**
```bash
# Check restore directory permissions
ls -la restore_data/
chmod 700 restore_data/

# Check PostgreSQL logs
cat restore_data/log/postgresql.log

# If corrupted, clean and retry
rm -rf restore_data/*
tar -xzf backups/base_backup.tar.gz -C restore_data/

# Start recovery
pg_ctl -D restore_data/ -o "-p 5433" start
```

---

### SQL Script Issues

#### Issue: "ERROR: relation 'X' does not exist"
**Cause:** Table not created or wrong database selected

**Solution:**
```bash
# Check current database
psql -U engineer -d production_db -c "SELECT current_database();"

# List tables
psql -U engineer -d production_db -c "\dt"

# Run setup scripts in correct order
psql -U engineer -d production_db -f sample-db/commerce_db.sql
```

#### Issue: "ERROR: extension 'pgvector' does not exist"
**Cause:** Extension not installed in database

**Solution:**
```bash
# Create extension
psql -U engineer -d production_db -c "CREATE EXTENSION IF NOT EXISTS vector;"

# Verify extension installed
psql -U engineer -d production_db -c "\dx"
```

#### Issue: "SQL script runs but produces no output"
**Cause:** Silent failures or no results

**Solution:**
```bash
# Run with verbose logging
psql -U engineer -d production_db -E -f script.sql

# Add explicit SELECT at end
echo "SELECT count(*) FROM table_name;" >> script.sql

# Check for errors
psql -U engineer -d production_db -f script.sql 2>&1 | head -20
```

---

### Monitoring & Observability Issues

#### Issue: "Prometheus targets show 'DOWN'"
**Cause:** Scrape endpoint not accessible or misconfigured

**Solution:**
```bash
# Check Prometheus config
cat monitoring/prometheus_alerts.yml

# Verify scrape target is accessible
curl http://localhost:9090/metrics

# Check PostgreSQL exporter running
docker ps | grep exporter
```

#### Issue: "Grafana dashboard shows 'no data'"
**Cause:** Prometheus not collecting metrics or query wrong

**Solution:**
```bash
# Verify Prometheus has data
curl http://localhost:9090/api/v1/query?query=pg_up

# Check Grafana data source
Grafana UI → Data Sources → Test

# Verify metrics collection
docker logs pg-exporter
```

---

### Performance Issues

#### Issue: "Queries are very slow or timing out"
**Cause:** Missing indexes, resource constraints, or suboptimal plans

**Solution:**
```bash
# Check query plan
EXPLAIN ANALYZE SELECT * FROM large_table WHERE expensive_condition;

# Create necessary indexes
CREATE INDEX idx_on_column ON table_name(column_name);

# Check resource usage
docker stats

# Increase resource allocation in docker-compose.yml
# Increase PostgreSQL parameters in Environment or postgresql.conf
```

#### Issue: "pgbench stress test crashes"
**Cause:** Resource exhaustion or connection limits

**Solution:**
```bash
# Reduce concurrent clients
PGBENCH_CLIENTS=10  # Instead of 50

# Reduce duration
PGBENCH_DURATION=60  # Instead of 600

# Increase shared_buffers in PostgreSQL
# docker-compose.yml → Environment → POSTGRES_INITDB_ARGS
```

---

## 🔍 Diagnostic Commands

### PostgreSQL Health Check
```bash
# From container
docker exec pg_engineering_lab psql -U engineer -d production_db \
     -c "SELECT version(); SELECT pg_is_in_recovery();"

# Connection count
SELECT count(*) FROM pg_stat_activity;

# Active queries
SELECT query, state FROM pg_stat_activity WHERE state IS NOT NULL;
```

### Docker Diagnostics
```bash
# Container status
docker compose ps

# Container logs (last 50 lines)
docker compose logs -n 50 postgres

# Real-time logs
docker compose logs -f postgres

# Resource usage
docker stats

# Inspect network
docker network ls
docker network inspect bridge
```

### Kubernetes Diagnostics
```bash
# Cluster info
kubectl cluster-info

# Pod status
kubectl get pods -n citus
kubectl describe pod -n citus <pod-name>

# Pod logs
kubectl logs -n citus <pod-name>

# Persistent volumes
kubectl get pv
kubectl get pvc -n citus

# Events
kubectl get events -n citus
```

---

## 🛠️ Getting Additional Help

1. **Check Stage README**: Each `docs/N-*/README.md` has troubleshooting tips
2. **Review Lab Scripts**: Comments in `.sh` files explain expected behavior
3. **Database Logs**: `docker logs container_name` shows detailed errors
4. **PostgreSQL Documentation**: https://www.postgresql.org/docs/16/
5. **Issue Tracker**: Create GitHub issue with reproduction steps

---

## 📞 Report a Bug

When reporting issues, include:

1. **System info**: OS, Docker version, PostgreSQL version
2. **Error message**: Full error output
3. **Steps to reproduce**: Exact commands run
4. **Environment**: Docker/Kubernetes, resource constraints
5. **Relevant logs**: `docker logs`, `.sh` script output

Example issue template:
```
**System**: Ubuntu 22.04, Docker 24.0.0, PostgreSQL 16

**Issue**: Lab script hangs after 5 minutes

**Steps**:
1. docker compose up -d
2. ./docs/3-internals/run_lab.sh
3. Hangs after "Creating partitions..."

**Logs**:
[paste docker logs output]

**Expected**: Script completes in ~2 minutes
```

---

**Last Updated:** May 2024
**Version:** 1.0
