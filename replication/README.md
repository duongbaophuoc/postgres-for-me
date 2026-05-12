# replication/

This folder contains a Patroni-based PostgreSQL high availability configuration.

## What is included

- `patroni_config.yaml` - sample Patroni cluster configuration for a 3-node HA deployment.
- `REQUIREMENTS.md` - software and environment prerequisites.

## Purpose

Use this folder to explore PostgreSQL high availability, leader election, automatic failover, and replication orchestration with Patroni.

## Quick start

1. Review the configuration values in `patroni_config.yaml`.
   - `etcd.host` must point to a running etcd endpoint.
   - `connect_address` and `name` should be unique per node.
   - `data_dir` and `bin_dir` must match your host/container environment.

2. Prepare PostgreSQL and Patroni prerequisites.
   - Ensure PostgreSQL 16 is installed or available in your container.
   - Ensure etcd is running and reachable.
   - Install Patroni: `pip install patroni`

3. Create the replication user on PostgreSQL:

```sql
CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'repl_password';
```

4. Start a node with Patroni:

```powershell
patroni patroni_config.yaml
```

5. Check cluster status:

```powershell
patronictl -c patroni_config.yaml list
```

6. Validate PostgreSQL replication settings on the active node:

```sql
SHOW wal_level;
SHOW max_replication_slots;
SELECT * FROM pg_replication_slots;
```

## Failover test

- Stop the primary node and confirm another node is promoted.
- Use `patronictl -c patroni_config.yaml list` to verify the new leader.

## Notes

- This configuration assumes physical replication and `use_pg_rewind: true` for faster rejoin.
- Adjust the IP addresses and ports in `patroni_config.yaml` before deploying.
- Use `REQUIREMENTS.md` to confirm the correct versions of etcd, Patroni, and PostgreSQL.
