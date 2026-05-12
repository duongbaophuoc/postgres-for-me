-- Query to check table bloat
-- Truy vấn kiểm tra độ phình (bloat) của bảng
-- This is a simplified version for demonstration
-- Đây là phiên bản rút gọn để minh họa

SELECT
  schemaname, relname,
  n_dead_tup,
  n_live_tup,
  round(n_dead_tup * 100 / nullif(n_live_tup + n_dead_tup, 0),2) AS bloat_ratio
FROM pg_stat_all_tables
WHERE n_live_tup > 0
ORDER BY n_dead_tup DESC;
