# cdc/

This folder contains Change Data Capture (CDC) integration assets for PostgreSQL and Debezium.

## What is included

- `debezium_postgres_connector.json` - Debezium connector configuration for PostgreSQL logical decoding.
- `REQUIREMENTS.md` - required Kafka, Debezium, and PostgreSQL setup.

## Purpose

Use this folder to build a logical replication pipeline from PostgreSQL into Kafka via Debezium.

## Quick start

1. Configure PostgreSQL for logical replication. In `postgresql.conf`:

```conf
wal_level = logical
max_wal_senders = 10
max_replication_slots = 10
```

2. Restart PostgreSQL if necessary.

3. Create the replication user and publication:

```sql
CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'secret';
CREATE PUBLICATION dbz_publication FOR TABLE public.orders, public.users;
```

4. Start Kafka, Zookeeper, and Debezium Connect.

5. Register the connector:

```powershell
curl -X POST \
  -H "Content-Type: application/json" \
  --data @debezium_postgres_connector.json \
  http://localhost:8083/connectors
```

6. Verify connector status:

```powershell
curl http://localhost:8083/connectors/ecommerce-connector/status
```

## Connector details

- `database.server.name` becomes the Kafka prefix for topics.
- `table.include.list` controls which tables are captured.
- `plugin.name = pgoutput` uses PostgreSQL logical decoding.

## Notes

- Ensure the username/password in the connector JSON matches the replication user.
- Use `REQUIREMENTS.md` to confirm the required Kafka and Debezium versions.
- If you need a broader pipeline, add a Kafka consumer or stream processing layer after the connector.
