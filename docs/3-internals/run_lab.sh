#!/usr/bin/env bash
set -euo pipefail

DB_NAME=${DB_NAME:-production_db}
DB_USER=${DB_USER:-engineer}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

echo "Running Stage 3 internals lab against ${DB_NAME}@${DB_HOST}:${DB_PORT} as ${DB_USER}"

psql_args=("-h" "${DB_HOST}" "-p" "${DB_PORT}" "-U" "${DB_USER}" "-d" "${DB_NAME}")

psql "${psql_args[@]}" <<'SQL'
DROP TABLE IF EXISTS performance_orders;
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
FROM generate_series(1, 100000);

ALTER TABLE performance_orders SET (autovacuum_enabled = false);
UPDATE performance_orders SET notes = repeat('updated-', 20) WHERE order_id % 10 = 0;
DELETE FROM performance_orders WHERE order_id % 20 = 0;
SQL

echo "Dataset created. Running storage and planner diagnostics..."

psql "${psql_args[@]}" <<'SQL'
CREATE INDEX IF NOT EXISTS idx_perf_order_date ON performance_orders(order_date);
ANALYZE performance_orders;
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_autovacuum FROM pg_stat_user_tables WHERE relname = 'performance_orders';
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM performance_orders WHERE order_date = '2024-06-01';
SET enable_seqscan = off;
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM performance_orders WHERE order_date = '2024-06-01';
SET enable_seqscan = on;
VACUUM VERBOSE performance_orders;
ANALYZE performance_orders;
SQL

if [ -f "inspect_storage.sql" ]; then
  echo "Running inspect_storage.sql..."
  psql "${psql_args[@]}" -f inspect_storage.sql
else
  echo "inspect_storage.sql not found in current folder. Skipping."
fi

echo "Stage 3 lab finished. Review the output and repeat the diagnostics after any schema change."
