-- Lab: Vacuum Failure and Table Bloat Simulation
-- Goal: Induce artificial bloat and observe its impact

-- 1. Create a table with many columns
CREATE TABLE bloat_test (
    id SERIAL PRIMARY KEY,
    data TEXT,
    created_at TIMESTAMP DEFAULT now()
);

-- 2. Insert 100,000 rows
INSERT INTO bloat_test (data) 
SELECT 'some initial data' FROM generate_series(1, 100000);

-- 3. Inhibit Autovacuum (CRITICAL for simulation)
ALTER TABLE bloat_test SET (autovacuum_enabled = false);

-- 4. Update all rows multiple times to create dead tuples
UPDATE bloat_test SET data = 'updated data 1';
UPDATE bloat_test SET data = 'updated data 2';
UPDATE bloat_test SET data = 'updated data 3';

-- 5. Measure bloat
-- (Using pgstattuple to see free space and dead tuples)
CREATE EXTENSION IF NOT EXISTS pgstattuple;
SELECT * FROM pgstattuple('bloat_test');

-- 6. Clean up (VACUUM FULL will reclaim space but lock the table)
-- VACUUM FULL bloat_test;
