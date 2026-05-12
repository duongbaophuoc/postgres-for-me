# CDC (Change Data Capture) Engineering Requirements
## Yêu cầu Kỹ thuật Bắt thay đổi dữ liệu (CDC)

### 🎯 Objective / Mục tiêu
- Stream real-time database changes to Kafka using Debezium.
- Truyền luồng thay đổi CSDL thời gian thực tới Kafka sử dụng Debezium.

### 🛠️ Technical Stack / Công nghệ
- **PostgreSQL**: Source DB with `wal_level = logical`.
- **Debezium**: Kafka Connect source connector.
- **Apache Kafka**: Message broker.

### ⚙️ Critical Configuration / Cấu hình quan trọng
In `postgresql.conf`:
```conf
wal_level = logical
max_replication_slots = 10
max_wal_senders = 10
```

---

### 💻 Debezium Connector Config (JSON)
File: `debezium_postgres_connector.json`

```json
{
  "name": "ecommerce-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "replicator",
    "database.password": "secret",
    "database.dbname": "commerce_db",
    "database.server.name": "production",
    "table.include.list": "public.orders,public.users",
    "plugin.name": "pgoutput",
    "slot.name": "debezium_slot"
  }
}
```
