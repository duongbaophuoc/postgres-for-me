#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.citus.yml}"
COORD_NAME="${COORD_NAME:-citus_coordinator}"
WORKER1_NAME="${WORKER1_NAME:-citus_worker1}"
WORKER2_NAME="${WORKER2_NAME:-citus_worker2}"
WORKER1_SERVICE="${WORKER1_SERVICE:-worker1}"
WORKER2_SERVICE="${WORKER2_SERVICE:-worker2}"
CITUS_USER="${CITUS_USER:-citus}"
CITUS_DB="${CITUS_DB:-citus}"

echo "Starting Citus multi-node lab using ${COMPOSE_FILE}."
docker compose -f "${COMPOSE_FILE}" up -d

echo "Waiting for Citus coordinator to become available..."
until docker exec "${COORD_NAME}" pg_isready -U "${CITUS_USER}" -d "${CITUS_DB}" >/dev/null 2>&1; do
  sleep 2
  echo -n '.'
done

echo "Coordinator is ready. Waiting for workers..."
until docker exec "${WORKER1_NAME}" pg_isready -U "${CITUS_USER}" -d "${CITUS_DB}" >/dev/null 2>&1; do
  sleep 2
  echo -n '.'
done
until docker exec "${WORKER2_NAME}" pg_isready -U "${CITUS_USER}" -d "${CITUS_DB}" >/dev/null 2>&1; do
  sleep 2
  echo -n '.'
done

echo "All nodes are ready. Registering workers with coordinator..."
docker exec "${COORD_NAME}" psql -U "${CITUS_USER}" -d "${CITUS_DB}" -c "SELECT master_add_node('${WORKER1_SERVICE}', 5432);"
docker exec "${COORD_NAME}" psql -U "${CITUS_USER}" -d "${CITUS_DB}" -c "SELECT master_add_node('${WORKER2_SERVICE}', 5432);"

echo "Creating distributed table and inserting sample data..."
docker exec citus_coordinator psql -U citus -d citus <<'SQL'
DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
  order_id serial PRIMARY KEY,
  customer_id int,
  order_date date,
  amount numeric(10,2)
);
SELECT create_distributed_table('orders', 'customer_id');

INSERT INTO orders (customer_id, order_date, amount)
SELECT (random() * 100)::int,
       date '2024-01-01' + (random() * 30)::int,
       round(random() * 1000, 2)
FROM generate_series(1, 10000);
SQL

echo "Querying the distributed table..."
docker exec citus_coordinator psql -U citus -d citus -c "SELECT count(*) FROM orders;"
docker exec citus_coordinator psql -U citus -d citus -c "EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 42;"

echo "Citus multi-node lab complete. Use 'docker compose -f ${COMPOSE_FILE} down' to stop the cluster."