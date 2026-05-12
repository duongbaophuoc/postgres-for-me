#!/usr/bin/env bash
set -euo pipefail

DB_NAME=${DB_NAME:-production_db}
DB_USER=${DB_USER:-engineer}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

echo "Running Stage 5 distributed systems lab against ${DB_NAME}@${DB_HOST}:${DB_PORT} as ${DB_USER}"

psql_args=("-h" "${DB_HOST}" "-p" "${DB_PORT}" "-U" "${DB_USER}" "-d" "${DB_NAME}")

echo "1) Creating partitioned table and sample data..."
psql "${psql_args[@]}" <<'SQL'
DROP TABLE IF EXISTS measurement CASCADE;
CREATE TABLE measurement (
    city_id         int not null,
    logdate         date not null,
    peaktemp        int,
    unitsales       int
) PARTITION BY RANGE (logdate);

CREATE TABLE measurement_y2023m01 PARTITION OF measurement
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

CREATE TABLE measurement_y2023m02 PARTITION OF measurement
    FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');

INSERT INTO measurement (city_id, logdate, peaktemp, unitsales)
SELECT (random() * 100)::int,
       date '2023-01-01' + (random() * 60)::int,
       (random() * 40)::int,
       (random() * 500)::int
FROM generate_series(1, 100000);
SQL

echo "2) Validating partition pruning..."
psql "${psql_args[@]}" <<'SQL'
EXPLAIN ANALYZE SELECT * FROM measurement WHERE logdate BETWEEN '2023-01-01' AND '2023-01-31';
SQL

echo "3) Checking table partitions..."
psql "${psql_args[@]}" -c "SELECT relname FROM pg_partitioned_table JOIN pg_class ON pg_partitioned_table.partrelid = pg_class.oid;"

if psql "${psql_args[@]}" -c "CREATE EXTENSION IF NOT EXISTS citus;" >/dev/null 2>&1; then
  echo "4) Citus extension installed, setting up sample distributed table metadata..."
  psql "${psql_args[@]}" <<'SQL'
CREATE TABLE IF NOT EXISTS distributed_orders (
  order_id UUID PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  amount NUMERIC(10,2)
);
SELECT create_distributed_table('distributed_orders', 'customer_id');
SQL
else
  echo "4) Citus extension unavailable. Skipping Citus distributed table setup."
fi

echo "Stage 5 lab finished. Review the EXPLAIN output and distribution metadata."