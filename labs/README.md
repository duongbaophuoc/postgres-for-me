# labs/

This folder contains hands-on PostgreSQL engineering lab exercises and simulation assets.

## What is included

- `planner_regression_lab.md` - Practical lab for query planner regression and index optimization.
- `vacuum_failure_lab.md` - Practical lab for MVCC, vacuum failures, and transaction wraparound.
- `vacuum_simulation.sql` - SQL script to simulate vacuum behavior and bloat scenarios.

## Purpose

Use these lab exercises to move from conceptual understanding to real operational practice.
They are especially useful after reviewing the corresponding docs in `docs/3-internals/` and `docs/4-operations/`.

## Quick start

1. Start the local PostgreSQL environment from `docker/`:

```powershell
cd e:\ABC\NoSQL\PostgreSQL\docker
docker compose up -d
```

2. Connect to PostgreSQL:

```powershell
docker compose exec postgres psql -U engineer -d production_db
```

3. Open the lab files and follow the exercise steps.
   - `labs/planner_regression_lab.md`
   - `labs/vacuum_failure_lab.md`

4. Use `vacuum_simulation.sql` to load and inspect sample data:

```powershell
docker compose exec -T postgres psql -U engineer -d production_db < ..\labs\vacuum_simulation.sql
```

5. Observe behavior with:

```sql
SELECT * FROM pg_stat_activity;
SELECT relname, n_live_tup, n_dead_tup FROM pg_stat_user_tables;
```

## Recommended workflow

- Read the lab objective.
- Load the sample dataset.
- Run the SQL and monitoring queries.
- Compare the results against the expected operational symptoms.
- Use `EXPLAIN ANALYZE`, `pg_stat_statements`, and `pg_locks` as needed.

## Notes

- The labs are designed to be executed in a containerized local environment for safety.
- Combine them with the `docker/`, `cdc/`, `monitoring/`, and `replication/` guides for a full production engineering practice path.
