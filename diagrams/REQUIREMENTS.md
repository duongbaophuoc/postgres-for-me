# Architecture Diagrams Requirements
## Yêu cầu Kỹ thuật Sơ đồ Kiến trúc

### 🎯 Objective / Mục tiêu
- Visualize complex PostgreSQL architectures (HA, Distributed, CDC) using Mermaid.js.
- Trực quan hóa kiến trúc PostgreSQL phức tạp bằng Mermaid.js.

---

### 💻 Sample: High Availability Cluster Architecture
File: `ha_cluster.mermaid`

```mermaid
graph TD
    User((User/App)) --> LB[HAProxy/Load Balancer]
    LB -->|Port 6432| PB[PgBouncer]
    PB -->|Primary| P1[(Postgres Primary)]
    P1 -->|Streaming Replication| S1[(Postgres Standby 1)]
    P1 -->|Streaming Replication| S2[(Postgres Standby 2)]
    
    subgraph "HA Orchestration"
        Patroni1[Patroni] <--> P1
        Patroni2[Patroni] <--> S1
        Patroni3[Patroni] <--> S2
        Patroni1 & Patroni2 & Patroni3 <--> ETCD[(etcd Cluster)]
    end
```

### 📋 Recommended Tools
- **Excalidraw**: For hand-drawn style architecture.
- **Mermaid.js**: For version-controlled diagrams in Markdown.
- **draw.io**: For detailed network diagrams.
