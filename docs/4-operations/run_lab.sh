#!/usr/bin/env bash
set -euo pipefail

DB_NAME=${DB_NAME:-production_db}
DB_USER=${DB_USER:-postgres}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
BACKUP_DIR=${BACKUP_DIR:-$(pwd)/backups}

mkdir -p "${BACKUP_DIR}"

echo "Running Stage 4 operations lab against ${DB_NAME}@${DB_HOST}:${DB_PORT} as ${DB_USER}"

psql_args=("-h" "${DB_HOST}" "-p" "${DB_PORT}" "-U" "${DB_USER}" "-d" "${DB_NAME}")

echo "1) Running logical backup..."
pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -Fc "${DB_NAME}" > "${BACKUP_DIR}/${DB_NAME}_$(date +%Y-%m-%d_%H-%M-%S).dump"

echo "2) Running ANALYZE..."
psql "${psql_args[@]}" -c "ANALYZE;"

echo "3) Listing superusers..."
psql "${psql_args[@]}" -c "SELECT usename FROM pg_user WHERE usesuper = true;"

echo "4) Checking pg_hba.conf rules..."
psql "${psql_args[@]}" -c "SELECT * FROM pg_hba_file_rules;"

echo "5) Validating replication settings..."
psql "${psql_args[@]}" -c "SELECT name, setting FROM pg_settings WHERE name IN ('wal_level','max_wal_senders','archive_mode','hot_standby');"

echo "6) Cleaning old backups older than 7 days..."
find "${BACKUP_DIR}" -type f -name "*.dump" -mtime +7 -delete

echo "Stage 4 lab completed. Backups stored in ${BACKUP_DIR}."
