-- Stage 2: Backend Integration Patterns
-- Transactions, Locking, and Cursor Pagination

-- 1. Optimistic Locking Simulation (Using a version column)
-- UPDATE products SET stock = stock - 1, version = version + 1 
-- WHERE id = ? AND version = current_version;

-- 2. Pessimistic Locking (Row-level)
BEGIN;
SELECT * FROM orders WHERE order_id = '...' FOR UPDATE;
-- Process order...
COMMIT;

-- 3. Cursor-based Pagination (Performance for large datasets)
-- Avoid OFFSET for deep pages
SELECT * FROM logs 
WHERE created_at < '2024-05-11 10:00:00' 
ORDER BY created_at DESC 
LIMIT 50;

-- 4. Advisory Locks (Application-level coordination)
SELECT pg_advisory_lock(12345);
-- Critical section...
SELECT pg_advisory_unlock(12345);
