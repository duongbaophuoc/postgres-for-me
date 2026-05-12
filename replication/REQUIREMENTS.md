# Replication & High Availability Engineering Requirements
## Yêu cầu Kỹ thuật Sao chép & Tính sẵn sàng cao (HA)

### 🎯 Objective / Mục tiêu
- Configure a 3-node PostgreSQL cluster with Patroni for automatic failover.
- Cấu hình cụm PostgreSQL 3 node với Patroni để tự động chuyển vùng khi có lỗi.

### 🛠️ Technical Stack / Công nghệ
- **Patroni**: HA template.
- **etcd**: Distributed configuration store (DCS).
- **HAProxy**: Load balancer for routing to the current Primary.

---

### 💻 Sample Patroni Configuration (YAML)
File: `patroni_node_config.yaml`

```yaml
scope: pg_cluster
name: pg_node_1

etcd:
  host: 127.0.0.1:2379

bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
      use_pg_rewind: true
      parameters:
        wal_level: logical
        max_wal_senders: 10
        max_replication_slots: 10

postgresql:
  listen: 0.0.0.0:5432
  connect_address: 192.168.1.10:5432
  data_dir: /var/lib/postgresql/data
  pgpass: /tmp/pgpass
  authentication:
    replication:
      username: replicator
      password: replicator_password
    superuser:
      username: postgres
      password: postgres_password
```
