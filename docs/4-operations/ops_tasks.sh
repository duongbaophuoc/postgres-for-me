#!/bin/bash
# Stage 4: Production Operations
# Basic Backup and Restore automation script

DB_NAME="production_db"
DB_USER="${DB_USER:-engineer}"
BACKUP_DIR="/backups/postgres"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# 1. Logical Backup (pg_dump)
echo "Starting logical backup for $DB_NAME..."
pg_dump -U "$DB_USER" -Fc "$DB_NAME" > "$BACKUP_DIR/${DB_NAME}_$DATE.dump"

# 2. Maintenance: Analyze and Reindex (Optional but recommended)
echo "Running ANALYZE..."
psql -U "$DB_USER" -d "$DB_NAME" -c "ANALYZE;"

# 3. Security Check: List users with Superuser privileges
echo "Checking superusers..."
psql -U "$DB_USER" -c "SELECT usename FROM pg_user WHERE usesuper = true;"

# 4. Clean old backups (Older than 7 days)
find $BACKUP_DIR -type f -name "*.dump" -mtime +7 -delete
echo "Backup process completed."
