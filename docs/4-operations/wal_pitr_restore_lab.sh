#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR=${BACKUP_DIR:-$(pwd)/backups}
WAL_DIR=${WAL_DIR:-${BACKUP_DIR}/wal_archive}
RESTORE_DIR=${RESTORE_DIR:-$(pwd)/restore_data}
RESTORE_DB=${RESTORE_DB:-restored_pitr_db}
TARGET_TIME=${TARGET_TIME:-"2024-01-01 00:00:00"}

mkdir -p "${RESTORE_DIR}"

echo "WAL/PITR restore lab"
echo "Base backup dir: ${BACKUP_DIR}"
echo "WAL archive dir: ${WAL_DIR}"
echo "Restore target dir: ${RESTORE_DIR}"

echo "Finding latest base backup file..."
LATEST_BASE=$(find "${BACKUP_DIR}" -maxdepth 1 -type f \( -name '*.tar' -o -name '*.tar.gz' \) | sort | tail -n 1)

if [ -z "${LATEST_BASE}" ]; then
  echo "No base backup tar found in ${BACKUP_DIR}."
  exit 1
fi

echo "Latest base backup: ${LATEST_BASE}"

echo "Extracting base backup..."
tar -xvf "${LATEST_BASE}" -C "${RESTORE_DIR}"

touch "${RESTORE_DIR}/recovery.signal"
cat > "${RESTORE_DIR}/postgresql.auto.conf" <<EOF
restore_command = 'cp ${WAL_DIR}/%f "%p"'
recovery_target_time = '${TARGET_TIME}'
recovery_target_action = 'promote'
EOF

echo "Starting temporary PostgreSQL instance for recovery..."
pg_ctl -D "${RESTORE_DIR}" -o "-p 5433" start

echo "Waiting for recovery to finish..."
while ! pg_isready -p 5433 >/dev/null 2>&1; do
  sleep 2
  echo -n '.'
done

echo "Recovery instance started on port 5433. Verify restored database content:"
psql -p 5433 -c "SELECT datname FROM pg_database WHERE datname = '${RESTORE_DB}';"

echo "When done, stop the recovery instance with: pg_ctl -D '${RESTORE_DIR}' stop"
