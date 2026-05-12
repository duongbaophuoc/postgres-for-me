-- Stage 7: Observability & Incident Engineering
-- Monitoring queries for production health

-- 1. Find Long Running Queries
SELECT 
    pid, 
    now() - query_start AS duration, 
    query, 
    state 
FROM pg_stat_activity 
WHERE state != 'idle' 
AND (now() - query_start) > interval '1 minute'
ORDER BY duration DESC;

-- 2. Check for Table Bloat (Estimated)
SELECT
  relname AS table_name,
  pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
  pg_size_pretty(pg_relation_size(relid)) AS data_size,
  pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS external_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- 3. Index Usage Statistics
SELECT 
    relname, 
    100 * idx_scan / (seq_scan + idx_scan) AS index_usage_pct, 
    n_live_tup 
FROM pg_stat_user_tables 
WHERE (seq_scan + idx_scan) > 0 
ORDER BY index_usage_pct DESC;
