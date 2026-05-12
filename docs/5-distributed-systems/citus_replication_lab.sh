#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  cat <<'USAGE'
Usage: ./citus_replication_lab.sh <publisher_conn> <subscriber_conn>

Example:
  ./citus_replication_lab.sh "host=publisher dbname=prod user=replicator password=secret" "host=subscriber dbname=prod user=replicator password=secret"
USAGE
  exit 1
fi

PUBLISHER_CONN="$1"
SUBSCRIBER_CONN="$2"

echo "Setting up logical replication lab with publisher and subscriber"

psql "${PUBLISHER_CONN}" <<'SQL'
CREATE TABLE IF NOT EXISTS replicated_orders (
  order_id UUID PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  amount NUMERIC(12,2)
);
CREATE PUBLICATION all_tables FOR TABLE replicated_orders;
SQL

echo "Created publication on publisher. Now create subscription on subscriber."

psql "${SUBSCRIBER_CONN}" <<'SQL'
CREATE TABLE IF NOT EXISTS replicated_orders (
  order_id UUID PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  amount NUMERIC(12,2)
);
CREATE SUBSCRIPTION sub_all_orders
  CONNECTION '${PUBLISHER_CONN}'
  PUBLICATION all_tables;
SQL

echo "Logical replication setup complete."

echo "Publisher status:"
psql "${PUBLISHER_CONN}" -c "SELECT * FROM pg_publication;"

echo "Subscriber status:"
psql "${SUBSCRIBER_CONN}" -c "SELECT * FROM pg_subscription;"
