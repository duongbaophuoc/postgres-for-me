#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${NAMESPACE:-citus}
MANIFEST=${MANIFEST:-citus-k8s.yaml}
COORD_SERVICE=${COORD_SERVICE:-citus-coordinator}
WORKER_SERVICE=${WORKER_SERVICE:-citus-worker}
COORD_POD_LABEL="app=citus-coordinator"
WORKER_POD_LABEL="app=citus-worker"

echo "Deploying Citus multi-node lab to namespace ${NAMESPACE}."
kubectl apply -f "${MANIFEST}"

echo "Waiting for coordinator pod..."
while [ "$(kubectl get pods -n "${NAMESPACE}" -l "${COORD_POD_LABEL}" -o jsonpath='{.items[0].status.phase}')" != "Running" ]; do
  sleep 3
  echo -n '.'
done

echo "Waiting for worker pods..."
while [ "$(kubectl get pods -n "${NAMESPACE}" -l "${WORKER_POD_LABEL}" -o jsonpath='{.items[0].status.phase}')" != "Running" ]; do
  sleep 3
  echo -n '.'
done

COORD_POD=$(kubectl get pod -n "${NAMESPACE}" -l "${COORD_POD_LABEL}" -o jsonpath='{.items[0].metadata.name}')
WORKER1_POD=$(kubectl get pod -n "${NAMESPACE}" -l "${WORKER_POD_LABEL}" -o jsonpath='{.items[0].metadata.name}')
WORKER2_POD=$(kubectl get pod -n "${NAMESPACE}" -l "${WORKER_POD_LABEL}" -o jsonpath='{.items[1].metadata.name}')

echo "Coordinator pod: ${COORD_POD}"
echo "Worker pods: ${WORKER1_POD}, ${WORKER2_POD}"

echo "Registering workers with coordinator..."
kubectl exec -n "${NAMESPACE}" "${COORD_POD}" -- psql -U citus -d citus -c "SELECT master_add_node('${WORKER1_POD}.${WORKER_SERVICE}.${NAMESPACE}.svc.cluster.local', 5432);"
kubectl exec -n "${NAMESPACE}" "${COORD_POD}" -- psql -U citus -d citus -c "SELECT master_add_node('${WORKER2_POD}.${WORKER_SERVICE}.${NAMESPACE}.svc.cluster.local', 5432);"

echo "Creating distributed table and inserting sample data..."
kubectl exec -n "${NAMESPACE}" "${COORD_POD}" -- psql -U citus -d citus <<'SQL'
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
kubectl exec -n "${NAMESPACE}" "${COORD_POD}" -- psql -U citus -d citus -c "SELECT count(*) FROM orders;"
kubectl exec -n "${NAMESPACE}" "${COORD_POD}" -- psql -U citus -d citus -c "EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 42;"

echo "Citus Kubernetes lab complete."

echo "To teardown: kubectl delete -f ${MANIFEST}"
