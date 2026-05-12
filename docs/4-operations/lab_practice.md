# Stage 4 Lab Practice: Operations & Reliability
## Bài lab Giai đoạn 4: Vận hành Production và Khả năng phục hồi

### Mục tiêu
- Thực hành backup/restore cơ bản.
- Kiểm tra bảo mật và quyền người dùng.
- Khám phá replication/HA và failover.

### Yêu cầu
- PostgreSQL đã chạy.
- Quyền sử dụng `pg_dump`, `pg_basebackup`, và `psql`.
- Nếu dùng Docker, khởi động container từ `docker/`.

### Bước 1: Backup logic với `ops_tasks.sh`

1. Mở terminal tại folder `docs/4-operations/`.
2. Chỉnh sửa biến `BACKUP_DIR` nếu cần.
3. Chạy script:

```bash
bash ops_tasks.sh
```

4. Kiểm tra thư mục backup và xác thực file `.dump`.

### Bước 2: Tạo backup vật lý với `pg_basebackup`

```bash
mkdir -p ../../backups/physical
pg_basebackup -h localhost -U engineer -D ../../backups/physical -Ft -X stream
```

### Bước 3: Kiểm tra replication và WAL

```sql
SELECT * FROM pg_stat_replication;
SELECT slot_name, database, active FROM pg_replication_slots;
SELECT name, setting FROM pg_settings WHERE name IN ('wal_level','max_wal_senders','archive_mode');
```

### Bước 4: Giả lập failover / switchover

- Nếu dùng Patroni, dùng:

```bash
patronictl -c ../../replication/patroni_config.yaml list
patronictl -c ../../replication/patroni_config.yaml failover
```

- Nếu không, dừng primary và kiểm tra standby.

### Bước 5: Kiểm tra bảo mật

```sql
SELECT usename, usesuper FROM pg_user;
SELECT * FROM pg_hba_file_rules;
```

### Bước 6: Khôi phục backup test

1. Tạo thư mục mới:

```bash
mkdir -p /tmp/pg_restore
```

2. Giải nén backup cấu trúc:

```bash
tar -xvf /tmp/pg_backup/base.tar -C /tmp/pg_restore
```

3. Khởi động PostgreSQL tạm trên dữ liệu phục hồi.

### Kết luận lab
- Ghi lại trạng thái backup và restore.
- Xác thực rằng `ANALYZE` và `REINDEX` được chạy sau backup.
- Kiểm tra cấu hình replication và quyền truy cập.
