# Stage 5 Lab Practice: Distributed PostgreSQL Systems
## Bài lab Giai đoạn 5: Phân mảnh, CDC và Kết nối phân tán

### Mục tiêu
- Thực hành partitioned table và query pruning.
- Thực hành thiết lập publication/subscription logic.
- Hiểu kết nối pooling và multi-region pattern.

### Yêu cầu
- PostgreSQL đang chạy.
- Quyền tạo bảng, publication và subscription.

### Bước 1: Tạo bảng phân vùng

```bash
psql -h localhost -U engineer -d production_db -f ./partition_setup.sql
```

### Bước 2: Nạp dữ liệu mẫu vào bảng phân vùng

```sql
INSERT INTO measurement (city_id, logdate, peaktemp, unitsales)
SELECT (random() * 100)::int,
       date '2023-01-01' + (random() * 90)::int,
       (random() * 40)::int,
       (random() * 500)::int
FROM generate_series(1, 200000);
```

### Bước 3: Kiểm tra partition pruning

```sql
EXPLAIN ANALYZE SELECT * FROM measurement WHERE logdate BETWEEN '2023-01-01' AND '2023-01-31';
```

- Xác định xem planner chỉ truy vấn partition `measurement_y2023m01`.

### Bước 4: Thiết lập logical replication mẫu

```sql
-- Trên publisher
CREATE PUBLICATION all_tables FOR ALL TABLES;

-- Trên subscriber
CREATE SUBSCRIPTION sub_all_tables
  CONNECTION 'host=postgres_primary dbname=production_db user=replicator password=replicator_secret'
  PUBLICATION all_tables;
```

### Bước 5: Thực hành connection pooling

- Nếu có PgBouncer, cấu hình minimal pool với `pool_mode = transaction`.
- Thử dùng nhiều kết nối đồng thời và kiểm tra `pg_stat_activity`.

### Bước 6: Mở rộng thành case study multi-region

- Giả định mỗi vùng có một cụm PostgreSQL read/write.
- Dữ liệu sự kiện và dimension replication cho warehouse.
- Sử dụng partitioning theo tháng và publication/subscription để đồng bộ dữ liệu giữa các vùng.

### Kết luận lab
- Ghi lại hiệu quả partition pruning.
- Ghi lại trạng thái subscription và replication lag.
- Thảo luận trade-off giữa consistency và availability khi triển khai đa vùng.
