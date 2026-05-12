# projects/

This folder contains PostgreSQL project artifacts and reference SQL for platform-level architecture.

## What is included

- `setup_global_platform.sql` - example SQL for a global e-commerce analytics platform.
- `REQUIREMENTS.md` - notes on the dependencies and environment required to run the sample.

## Purpose

Use this folder to study how PostgreSQL schema design supports project-level requirements such as multi-region analytics, star schema modeling, and partitioned fact tables.

## Case Study: Multi-region Analytics Platform

This example models a global e-commerce architecture where:

- Operational data is captured in OLTP tables.
- Analytical reporting is built in a `warehouse` schema.
- Fact data is partitioned by month for performance.
- Dimension tables support current/historical records.
- Global reporting is exposed through a dashboard view.

### Architecture highlights

- `warehouse.dim_customer` stores customer dimensions with current row tracking.
- `warehouse.fact_orders` separates event data for analytics.
- Monthly partitions reduce query scan volume and simplify rolling retention.
- `global_sales_overview` demonstrates a production-ready analytics aggregation.

## Quick start

1. Connect to PostgreSQL:

```powershell
psql -U engineer -d production_db
```

2. Run the sample script:

```powershell
psql -U engineer -d production_db -f e:\ABC\NoSQL\PostgreSQL\projects\setup_global_platform.sql
```

3. Verify the warehouse schema and objects:

```sql
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'warehouse';
SELECT tablename FROM pg_tables WHERE schemaname = 'warehouse';
SELECT * FROM warehouse.global_sales_overview LIMIT 10;
```

## Practical notes

- The script includes a Citus-style distributed table comment. Use it when Citus is available.
- The example is designed to be analytics-ready and extendable to multi-region workflows.
- The `global_sales_overview` view demonstrates how operational and analytical data can be combined.
- For multi-region deployments, use logical replication or a distributed extension to synchronize regional writes.

