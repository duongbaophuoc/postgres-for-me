# docs/

This folder contains stage-based PostgreSQL learning content aligned with the roadmap.

## What is included

Each subfolder contains a stage-specific `README.md` plus supporting SQL or architecture examples:

- `0-data-modeling/`
- `1-fundamentals/`
- `2-backend-integration/`
- `3-internals/`
- `4-operations/`
- `5-distributed-systems/`
- `6-warehousing/`
- `7-observability/`
- `8-modern-ecosystem/`

## How to use this folder

1. Start with the stage that matches your current learning goal.
2. Read the stage README for core concepts, tools, and recommended exercises.
3. Apply the concepts in the hands-on labs from `../labs/` when available.

## Practical learning path

- `0-data-modeling/` -> schema design and relational trade-offs.
- `1-fundamentals/` -> PostgreSQL setup, SQL basics, and native features.
- `2-backend-integration/` -> ORM patterns, query engineering, and transaction design.
- `3-internals/` -> storage, MVCC, WAL, and planner behavior.
- `4-operations/` -> backups, replication, and production operations.
- `5-distributed-systems/` -> sharding, CDC, and scaling patterns.
- `6-warehousing/` -> analytics modeling, ETL/ELT, and warehouse architecture.
- `7-observability/` -> metrics, alerting, and incident response.
- `8-modern-ecosystem/` -> AI/pgvector, extension ecosystems, and modern PostgreSQL workloads.

## Link to labs

For hands-on practice, open the `labs/` folder:

- `labs/planner_regression_lab.md`
- `labs/vacuum_failure_lab.md`
- `labs/vacuum_simulation.sql`

Use the docs content as conceptual guidance and the labs for real troubleshooting exercises.
