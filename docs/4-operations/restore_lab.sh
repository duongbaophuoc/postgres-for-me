#!/usr/bin/env bash
set -euo pipefail

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-postgres}
BACKUP_DIR=${BACKUP_DIR:-$(pwd)/backups}
RESTORE_DB=${RESTORE_DB:-restored_db}

mkdir -p "${BACKUP_DIR}"

LATEST_DUMP=$(find "${BACKUP_DIR}" -maxdepth 1 -type f -name "*.dump" -printf '%T@ %p\n' | sort -nr | head -n 1 | cut -d' ' -f2-)

if [ -z "${LATEST_DUMP}" ]; then
  echo "No backup dump found in ${BACKUP_DIR}."
  exit 1
fi

echo "Found latest backup: ${LATEST_DUMP}"

echo "Dropping existing restore database if present..."
PGPASSWORD=${PGPASSWORD:-} psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -c "DROP DATABASE IF EXISTS ${RESTORE_DB};"

echo "Creating restore target database ${RESTORE_DB}..."
PGPASSWORD=${PGPASSWORD:-} psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -c "CREATE DATABASE ${RESTORE_DB};"

echo "Restoring ${LATEST_DUMP} into ${RESTORE_DB}..."
PGPASSWORD=${PGPASSWORD:-} pg_restore -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${RESTORE_DB}" --clean --if-exists "${LATEST_DUMP}"

echo "Verifying restore..."
PGPASSWORD=${PGPASSWORD:-} psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${RESTORE_DB}" -c "SELECT tablename FROM pg_tables WHERE schemaname NOT IN ('pg_catalog','information_schema') ORDER BY tablename LIMIT 20;"

echo "Restore validation complete. Restored DB is ${RESTORE_DB}."
