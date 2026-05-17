# diagrams/ — Architecture Diagrams
# diagrams/ — Sơ Đồ Kiến Trúc

This directory contains architecture diagrams for the PostgreSQL Infrastructure & Database Engineering Roadmap.

---

## Overall System Architecture

```mermaid
graph TB
    subgraph Client["Client Layer"]
        APP["Application / Backend"]
        BI["BI Tools (Grafana, Tableau)"]
    end

    subgraph Pool["Connection Layer"]
        PGB["PgBouncer\n(Connection Pooling)"]
    end

    subgraph HA["High Availability Cluster"]
        PAT["Patroni\n(HA Orchestrator)"]
        PRI["PostgreSQL Primary\n(Read + Write)"]
        REP1["Replica 1\n(Streaming)"]
        REP2["Replica 2\n(Streaming)"]
    end

    subgraph Infra["Infrastructure Layer"]
        WAL["WAL Archiving\n(WAL-G / S3)"]
        MON["Prometheus\n+ Grafana"]
        CDC["Debezium CDC\n-> Kafka"]
    end

    subgraph DW["Data Platform"]
        ETL["dbt / Airflow ETL"]
        WH["Analytics Warehouse\nanalytics_dw"]
        VEC["pgvector\nvector_search_db"]
    end

    APP --> PGB --> PRI
    BI --> REP1
    PRI --> REP1
    PRI --> REP2
    PAT --> PRI
    PRI --> WAL
    PRI --> CDC
    PRI --> MON
    CDC --> ETL --> WH
    WH --> VEC
```

---

## MVCC & Storage Internals

```mermaid
graph LR
    TXN["Transaction\nINSERT / UPDATE"] --> WAL_W["WAL Write\n(durability first)"]
    WAL_W --> SHB["Shared Buffers\n(dirty page)"]
    SHB --> BGW["Background Writer\n(periodic flush)"]
    BGW --> DISK["Heap Files\n(8KB pages)"]
    DISK --> MVCC["MVCC Tuple\n(xmin / xmax)"]
    MVCC --> VAC["VACUUM\n(dead tuple cleanup)"]
    VAC --> FSM["Free Space Map\n(reuse space)"]

    style TXN fill:#2d6a4f,color:#fff
    style VAC fill:#d62828,color:#fff
    style MVCC fill:#7b2d8b,color:#fff
```

---

## Replication Architecture

```mermaid
sequenceDiagram
    participant C as Client
    participant P as Primary
    participant W as WAL
    participant R1 as Replica 1
    participant R2 as Replica 2

    C->>P: COMMIT transaction
    P->>W: Write WAL record
    W-->>R1: Stream WAL (async)
    W-->>R2: Stream WAL (sync)
    R2-->>P: Acknowledge (sync_commit=on)
    P-->>C: Transaction confirmed
    Note over R1,R2: Hot Standby — readable
```

---

## 9-Stage Learning Path

```mermaid
graph LR
    S0["Stage 0\nData Modeling"] --> S1["Stage 1\nFundamentals"]
    S1 --> S2["Stage 2\nBackend Integration"]
    S2 --> S3["Stage 3\nInternals & MVCC"]
    S3 --> S4["Stage 4\nProduction Ops"]
    S4 --> S5["Stage 5\nDistributed Systems"]
    S5 --> S6["Stage 6\nWarehousing & ETL"]
    S6 --> S7["Stage 7\nObservability & SRE"]
    S7 --> S8["Stage 8\nAI & Vector Search"]

    style S0 fill:#52b788,color:#fff
    style S1 fill:#52b788,color:#fff
    style S2 fill:#f4d35e
    style S3 fill:#e63946,color:#fff
    style S4 fill:#7b2d8b,color:#fff
    style S5 fill:#1d3557,color:#fff
    style S6 fill:#795548,color:#fff
    style S7 fill:#1565c0,color:#fff
    style S8 fill:#e65100,color:#fff
```

---

## Files in This Directory

| File | Description |
|------|-------------|
| `README.md` | Architecture diagrams (Mermaid) |

> **Note:** Diagrams render automatically on GitHub. To view locally, use a Mermaid-compatible editor (e.g., VS Code with Mermaid Preview extension).