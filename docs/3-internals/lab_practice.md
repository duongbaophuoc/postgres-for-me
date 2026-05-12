# Stage 3 Lab Practice: Internals & Performance
## Bài lab Giai đoạn 3: Nội bộ PostgreSQL và Tối ưu hiệu năng

### Mục tiêu
- Thực hành tạo và phân tích tình huống MVCC/bloat.
- Sử dụng `EXPLAIN ANALYZE` để chẩn đoán planner.
- So sánh trước/sau `VACUUM`, `ANALYZE`, và tối ưu chỉ mục.

### Yêu cầu
- PostgreSQL 16 running.
- Nếu dùng Docker, khởi động stack trong `docker/`.
- Quyền tạo bảng và chạy `VACUUM`.

### Bước 1: Chuẩn bị bảng lớn và tạo bloat

```sql
CREATE TABLE performance_orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  amount NUMERIC(10,2),
  notes TEXT
);

INSERT INTO performance_orders (customer_id, order_date, amount, notes)
SELECT
  (random() * 1000)::int,
  date '2024-01-01' + (random() * 365)::int,
  round(random() * 1000, 2),
  repeat('bloat-', 20)
FROM generate_series(1, 1000000);

ALTER TABLE performance_orders SET (autovacuum_enabled = false);

UPDATE performance_orders SET notes = repeat('updated-', 20)
WHERE order_id % 10 = 0;

DELETE FROM performance_orders WHERE order_id % 20 = 0;
```

### Bước 2: Kiểm tra MVCC và bloat

```sql
SELECT relname,
       n_live_tup,
       n_dead_tup,
       last_vacuum,
       last_autovacuum
FROM pg_stat_user_tables
WHERE relname = 'performance_orders';

-- Nếu có extension pgstattuple:
CREATE EXTENSION IF NOT EXISTS pgstattuple;
SELECT * FROM pgstattuple('performance_orders');
```

### Bước 3: Chạy `EXPLAIN ANALYZE` và phân tích planner

```sql
CREATE INDEX idx_perf_order_date ON performance_orders(order_date);
ANALYZE performance_orders;

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM performance_orders WHERE order_date = '2024-06-01';

SET enable_seqscan = off;
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM performance_orders WHERE order_date = '2024-06-01';
SET enable_seqscan = on;
```

### Bước 4: So sánh VACUUM và tối ưu

```sql
VACUUM VERBOSE performance_orders;
ANALYZE performance_orders;

-- Nếu cần dọn sạch bloat mạnh:
VACUUM FULL performance_orders;
REINDEX TABLE performance_orders;
```

### Bước 5: Sử dụng `inspect_storage.sql`

- Chạy file `inspect_storage.sql` từ folder `docs/3-internals/`.
- So sánh số trang, dữ liệu trống và tỷ lệ hữu ích.

```bash
psql -U engineer -d production_db -f e:\ABC\NoSQL\PostgreSQL\docs\3-internals\inspect_storage.sql
```

### Kết luận lab
- Ghi lại số `n_dead_tup` trước và sau `VACUUM`.
- Ghi lại plan trước và sau `ANALYZE`.
- Quan sát tác động của `Enable_seqscan` và index.
- Hiểu cách bloat ảnh hưởng đến I/O và planner.
