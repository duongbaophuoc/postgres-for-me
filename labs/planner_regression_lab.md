# Lab: Query Planner Regression & Index Optimization
## Bài Lab: Suy giảm hiệu năng bộ lập lịch & Tối ưu hóa Index

### 🎯 Objective / Mục tiêu
- Diagnose why a query suddenly switches from Index Scan to Seq Scan. / Chẩn đoán tại sao truy vấn đột ngột chuyển từ Index Scan sang Seq Scan.
- Understand the impact of `SET enable_seqscan = off`. / Hiểu tác động của việc ép buộc tắt Seq Scan.
- Use `EXPLAIN ANALYZE` for technical diagnosis. / Sử dụng EXPLAIN ANALYZE để chẩn đoán kỹ thuật.

### 🛠️ Technical Requirements / Yêu cầu kỹ thuật
- Dataset size: > 1,000,000 rows.
- Tool: `EXPLAIN (ANALYZE, BUFFERS)`.

---

### 🚀 Investigation Steps / Các bước điều tra

#### 1. Setup Large Dataset
```sql
CREATE TABLE large_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Insert 1M rows with skewed distribution
INSERT INTO large_orders (customer_id, order_date, amount)
SELECT 
    (random() * 1000)::int, 
    '2020-01-01'::date + (random() * 1500)::int,
    random() * 1000
FROM generate_series(1, 1000000);

CREATE INDEX idx_order_date ON large_orders(order_date);
```

#### 2. The Regression Scenario
```sql
-- Normal query using index
EXPLAIN ANALYZE 
SELECT * FROM large_orders WHERE order_date = '2022-01-01';

-- Planner switches to Seq Scan because of high selectivity
-- Giả lập kịch bản truy vấn dải rộng khiến Planner bỏ Index
EXPLAIN ANALYZE 
SELECT * FROM large_orders WHERE order_date > '2020-01-01';
```

#### 3. Analyzing Buffers (Memory Impact)
```sql
-- Check how many pages were read from Shared Buffers vs Disk
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM large_orders WHERE customer_id = 500;
```

#### 4. Optimization: Statistics
```sql
-- Force statistics update
ANALYZE large_orders;

-- Check statistics histograms
SELECT * FROM pg_stats WHERE tablename = 'large_orders';
```
