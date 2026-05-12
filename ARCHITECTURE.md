# PostgreSQL Infrastructure & Database Engineering Architecture
## Kiến trúc Cơ sở hạ tầng & Kỹ thuật Cơ sở dữ liệu PostgreSQL

---

## 🏗️ System Architecture Overview

This repository implements a **production-grade PostgreSQL infrastructure** following a layered progression from fundamentals to distributed systems and AI integration.

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│ Stage 8: Modern Ecosystem (AI/ML, Vector Search, Time-Series)  │
├─────────────────────────────────────────────────────────────────┤
│ Stage 7: Observability (Prometheus, Grafana, Custom Metrics)   │
├─────────────────────────────────────────────────────────────────┤
│ Stage 6: Warehousing (Analytics DW, BI Integration, OLAP)      │
├─────────────────────────────────────────────────────────────────┤
│ Stage 5: Distributed Systems (Citus, Sharding, Multi-Region)   │
├─────────────────────────────────────────────────────────────────┤
│ Stage 4: Production Operations (HA, Failover, Backup/Recovery) │
├─────────────────────────────────────────────────────────────────┤
│ Stage 3: Internals (Query Planner, Storage, MVCC, Vacuum)      │
├─────────────────────────────────────────────────────────────────┤
│ Stage 2: Backend Integration (Transactions, Concurrency, Locks)│
├─────────────────────────────────────────────────────────────────┤
│ Stage 1: Fundamentals (SQL, Indexing, Optimization)            │
├─────────────────────────────────────────────────────────────────┤
│ Stage 0: Data Modeling (Schemas, Relationships, Constraints)   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Design Principles

### 1. **Hands-On Learning**
- Every stage includes practical lab scripts and SQL examples
- Real-world schema designs (e-commerce, analytics, vector search)
- Automated workflows for local development

### 2. **Production-Ready Patterns**
- High Availability (Patroni + streaming replication)
- Disaster Recovery (PITR, WAL archiving, backup validation)
- Connection pooling (PgBouncer for session/transaction pooling)
- Distributed query execution (Citus for horizontal scaling)

### 3. **Observability First**
- Prometheus metrics collection
- Grafana dashboards for performance monitoring
- Custom stat queries for internals inspection
- Log aggregation patterns

### 4. **Infrastructure as Code**
- Docker Compose for local multi-node labs
- Kubernetes manifests (StatefulSets, Services, PVCs)
- Helm value files for dev/staging/prod environments
- CloudNativePG operator patterns

---

## 📦 Component Architecture

### Data Layer

```
┌──────────────────────────────────────────┐
│ PostgreSQL Storage Engine                │
│  ├─ MVCC (Multi-Version Concurrency)    │
│  ├─ WAL (Write-Ahead Logging)           │
│  ├─ Buffer Pool & Cache Management      │
│  └─ Partitioning & Table Spaces         │
└──────────────────────────────────────────┘
        ↓
┌──────────────────────────────────────────┐
│ Replication Layer                        │
│  ├─ Streaming Replication (Physical)    │
│  ├─ Logical Replication                 │
│  ├─ Replication Slots                   │
│  └─ Failover Coordination (Patroni)     │
└──────────────────────────────────────────┘
        ↓
┌──────────────────────────────────────────┐
│ Distributed Query Layer (Citus)          │
│  ├─ Coordinator Node                    │
│  ├─ Worker Nodes                        │
│  └─ Distributed Table Management        │
└──────────────────────────────────────────┘
```

### Access Layer

```
┌──────────────────────────┐
│ Application              │
└────────┬─────────────────┘
         ↓
┌──────────────────────────────────────┐
│ Connection Pooling (PgBouncer)       │
│  ├─ Session Pooling                  │
│  ├─ Transaction Pooling              │
│  └─ Connection Reuse                 │
└────────┬─────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ PostgreSQL Primary                   │
└────────┬─────────────────────────────┘
         ↓
      Replicas (Hot Standby)
```

### Operational Layer

```
┌───────────────────────────────────────────────┐
│ Monitoring & Alerting                         │
│  ├─ Prometheus (Metrics Collection)           │
│  ├─ Grafana (Visualization)                   │
│  └─ AlertManager (Alerting)                   │
└───────────────────────────────────────────────┘
         ↑
┌───────────────────────────────────────────────┐
│ Database Cluster                              │
│  ├─ Primary (Write Path)                      │
│  ├─ Replicas (Read Path)                      │
│  └─ Standby (HA Failover)                     │
└───────────────────────────────────────────────┘
         ↑
┌───────────────────────────────────────────────┐
│ Backup & Recovery                             │
│  ├─ Base Backups (pg_basebackup)              │
│  ├─ WAL Archiving (S3/GCS)                    │
│  └─ PITR (Point-In-Time Recovery)             │
└───────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Patterns

### Write Path (OLTP)
```
App → PgBouncer (transaction pool) → Primary → WAL → Replicas
```

### Read Path (OLAP via Citus)
```
Analytics App → Coordinator → Distributed Query → Workers
```

### CDC Pipeline
```
PostgreSQL Logical Decoding → Debezium → Kafka → Event Consumers
```

### Backup & Recovery
```
Primary → pg_basebackup + WAL Archive → Cloud Storage → PITR Restore
```

---

## 🛠️ Technology Stack

| Component | Purpose | Technology |
|-----------|---------|-----------|
| **Data Store** | Primary DB | PostgreSQL 16 |
| **Horizontal Scaling** | Distributed Query | Citus 11 |
| **Replication** | HA & Standby | Streaming Replication + Patroni |
| **Connection Pooling** | Resource Management | PgBouncer |
| **Change Capture** | Event Streaming | Debezium + Kafka |
| **Vector Search** | AI/RAG | pgvector + HNSW |
| **Observability** | Monitoring | Prometheus + Grafana |
| **Orchestration** | Container Mgmt | Docker Compose / Kubernetes |
| **Infrastructure** | K8s Operator | CloudNativePG |
| **Backup** | Disaster Recovery | pg_basebackup + WAL-G |

---

## 🚀 Deployment Topologies

### Development
- Single PostgreSQL container (Docker)
- Local pgAdmin for visualization
- Minimal resource requirements

### Staging
- 3-node PostgreSQL cluster (Primary + 2 Replicas)
- Patroni for HA coordination
- Prometheus metrics collection

### Production
- Multi-region PostgreSQL deployment
- Citus coordinator + worker nodes
- Automated backup & recovery
- Alerting & on-call automation
- CDN + caching layer

---

## 📊 Key Design Decisions

### 1. **Why Citus for Distributed Queries?**
- ✅ Extends PostgreSQL natively (not separate cluster)
- ✅ Familiar SQL interface for distributed queries
- ✅ Production-battle-tested at scale

### 2. **Why Patroni for HA?**
- ✅ Automated failover without manual intervention
- ✅ etcd/Consul/Zookeeper for distributed consensus
- ✅ Native PostgreSQL streaming replication

### 3. **Why pgvector for Vector Search?**
- ✅ Native PostgreSQL extension (ACID compliance)
- ✅ HNSW indexing for fast approximate search
- ✅ Simplifies RAG pipelines (no separate vector DB)

### 4. **Why Kubernetes for Orchestration?**
- ✅ Industry standard for container orchestration
- ✅ CloudNativePG operator for Postgres-specific features
- ✅ Multi-region deployment patterns

---

## 🔐 Security Architecture

```
┌─────────────────────────────────────────┐
│ Network Layer (SSL/TLS)                 │
├─────────────────────────────────────────┤
│ Authentication (SCRAM, Certificate)     │
├─────────────────────────────────────────┤
│ Authorization (RBAC, Row-Level Security)│
├─────────────────────────────────────────┤
│ Data Encryption (pgcrypto, at-rest)     │
├─────────────────────────────────────────┤
│ Audit Logging (pgaudit)                 │
└─────────────────────────────────────────┘
```

---

## 📈 Scalability Patterns

### Vertical Scaling
- Increase PostgreSQL server resources (CPU, RAM, Storage)
- Suitable for single-node workloads

### Horizontal Scaling (Citus)
- Add worker nodes to Citus cluster
- Distribute large tables across shards
- Distributed joins across nodes

### Replication Scaling
- Add hot standby replicas for read offloading
- Connection pooling for efficient replication

---

## 🔄 Decision Log

| Decision | Rationale | Trade-offs |
|----------|-----------|-----------|
| PostgreSQL 16 | Latest LTS, better performance | Newer versions may have breaking changes |
| Citus for distribution | Native Postgres extension | Learning curve for distributed SQL |
| Patroni for HA | Battle-tested, no vendor lock-in | Operational complexity |
| Docker Compose for labs | Easy local development | Not production-grade |
| Kubernetes for production | Industry standard, multi-region support | Operational overhead |
| Prometheus for monitoring | OSS, widely adopted | Manual query tuning required |

---

## 🎓 Learning Roadmap

**New to PostgreSQL?** Start with Stage 0 → Stage 1 → Stage 2

**HA/Backup operations?** Jump to Stage 4 → Lab scripts

**Distributed systems?** Jump to Stage 5 → Citus multi-node lab

**Analytics/Warehousing?** Jump to Stage 6 → dbt integration

**AI/Vector Search?** Jump to Stage 8 → vector_search lab

---

*For implementation details, see [SETUP.md](SETUP.md)*

*For troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)*
