# Lab: Vacuum Failure & MVCC Bloat Simulation
## Bài Lab: Giả lập lỗi Vacuum và Phình to dữ liệu MVCC

### 🎯 Objective / Mục tiêu
- Understand how MVCC creates dead tuples. / Hiểu cách MVCC tạo ra các bản ghi chết.
- Simulate a failure where autovacuum cannot keep up. / Giả lập lỗi khi autovacuum không theo kịp tốc độ thay đổi.
- Analyze table bloat using technical queries. / Phân tích độ phình của bảng bằng các truy vấn kỹ thuật.

### 🛠️ Technical Requirements / Yêu cầu kỹ thuật
- PostgreSQL 13+ (Docker environment).
- Database: `production_db`.
- Tool: `psql` or `pgAdmin`.

---

### 🚀 Simulation Steps / Các bước thực hiện

#### 1. Setup Table with Autovacuum Disabled
```sql
-- Create a high-update table
CREATE TABLE bloat_test (
    id SERIAL PRIMARY KEY,
    data TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
) WITH (autovacuum_enabled = false); -- DANGEROUS: Force manual control
```

#### 2. Generate Massive Updates (Simulate Workload)
```sql
-- Insert initial data
INSERT INTO bloat_test (data) 
SELECT 'Initial data ' || i FROM generate_series(1, 10000) s(i);

-- Perform 50 rounds of updates to create dead tuples
DO $$
BEGIN
    FOR i IN 1..50 LOOP
        UPDATE bloat_test SET data = 'Updated data ' || i, updated_at = NOW();
    END LOOP;
END $$;
```

#### 3. Analyze Bloat (The Technical Check)
```sql
-- Check the number of dead tuples
SELECT 
    relname, 
    n_live_tup, 
    n_dead_tup, 
    last_vacuum, 
    last_autovacuum 
FROM pg_stat_user_tables 
WHERE relname = 'bloat_test';

-- Estimate real table size vs actual disk size
SELECT
    pg_size_pretty(pg_total_relation_size('bloat_test')) AS total_size,
    pg_size_pretty(pg_relation_size('bloat_test')) AS table_size;
```

#### 4. Resolution
```sql
-- Manually run VACUUM ANALYZE
VACUUM ANALYZE bloat_test;

-- If bloat is severe, run VACUUM FULL (Locks the table!)
VACUUM FULL bloat_test;
```
