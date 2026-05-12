#!/usr/bin/env bash
set -euo pipefail

# Script: quick-demo.sh
# Purpose: Fast 5-minute demo of PostgreSQL labs for new users
# Usage: ./quick-demo.sh [stage]
# Stages: 0, 1, 3, 4, 5, 6, 8 (default: all)

DEMO_STAGE=${1:-all}
DB_NAME="production_db"
DB_USER="engineer" # Unified with SETUP.md and .env
DB_PORT="5432"
DB_HOST="localhost"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🐘 PostgreSQL Engineering Roadmap - Quick Demo${NC}"
echo "=================================================="

# Check if PostgreSQL is running
check_pg() {
  if ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" >/dev/null 2>&1; then
    echo "❌ PostgreSQL not running on $DB_HOST:$DB_PORT"
    echo "Start with: docker compose -f docker/docker-compose.yml up -d"
    exit 1
  fi
  echo -e "${GREEN}✅ PostgreSQL is running${NC}"
}

# Demo Stage 0: Data Modeling
demo_stage_0() {
  echo -e "\n${BLUE}[Stage 0] Data Modeling - 1 minute${NC}"
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" <<'EOF'
-- Exclusion constraint demo (prevent overlapping schedules)
DROP TABLE IF EXISTS room_reservations CASCADE;
CREATE TABLE room_reservations (
    room_id INT,
    booking_period TSRANGE,
    EXCLUDE USING gist (room_id WITH =, booking_period WITH &&)
);

INSERT INTO room_reservations VALUES 
  (101, '[2024-01-01, 2024-01-05)'),
  (101, '[2024-01-10, 2024-01-15)');

SELECT 'Room reservations (overlapping prevented):' as demo;
SELECT room_id, booking_period FROM room_reservations ORDER BY room_id;
EOF
}

# Demo Stage 1: PostgreSQL Fundamentals
demo_stage_1() {
  echo -e "\n${BLUE}[Stage 1] PostgreSQL Fundamentals - 2 minutes${NC}"
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" <<'EOF'
-- Window Functions
DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales (
    month INT,
    amount DECIMAL(10, 2)
);

INSERT INTO sales VALUES 
  (1, 1000),
  (2, 1500),
  (3, 1200),
  (4, 1800);

SELECT 
    month,
    amount,
    SUM(amount) OVER (ORDER BY month) as running_total,
    ROW_NUMBER() OVER (ORDER BY amount DESC) as rank
FROM sales;
EOF
}

# Demo Stage 2: Backend Integration & Transactions
demo_stage_2() {
  echo -e "\n${BLUE}[Stage 2] Backend Integration (Transactions) - 1 minute${NC}"
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" <<'EOF'
-- Transaction Isolation Level Demo
DROP TABLE IF EXISTS account_balance;
CREATE TABLE account_balance (id INT, balance DECIMAL);
INSERT INTO account_balance VALUES (1, 1000);

BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT 'Current balance (Repeatable Read):' as info, balance FROM account_balance WHERE id = 1;

-- Simulate concurrent update (in a real app, this happens in another process)
-- In this demo, we'll just show the logic
UPDATE account_balance SET balance = balance - 100 WHERE id = 1;

COMMIT;

SELECT 'Final balance after transaction:' as info, balance FROM account_balance;
EOF
  echo -e "${GREEN}✅ Transaction demo completed${NC}"
}

# Demo Stage 3: Internals
demo_stage_3() {
  echo -e "\n${BLUE}[Stage 3] PostgreSQL Internals - 2 minutes${NC}"
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" <<'EOF'
-- MVCC & Dead Tuples Demo
DROP TABLE IF EXISTS mvcc_demo CASCADE;
CREATE TABLE mvcc_demo (id INT PRIMARY KEY, value TEXT);
INSERT INTO mvcc_demo VALUES (1, 'original');

-- Update creates new version
UPDATE mvcc_demo SET value = 'updated' WHERE id = 1;
UPDATE mvcc_demo SET value = 'updated again' WHERE id = 1;

-- Check dead tuples (requires pg_stat_user_tables extension)
-- pg_stat_user_tables is a system view, no extension needed.
SELECT schemaname, relname, n_live_tup, n_dead_tup, last_autovacuum
FROM pg_stat_user_tables
WHERE relname = 'mvcc_demo';

SELECT '--- MVCC creates multiple versions (demo) ---' as info;
EOF
}

# Demo Stage 4: Backup & Recovery
demo_stage_4() {
  echo -e "\n${BLUE}[Stage 4] Production Operations - 1 minute${NC}"
  echo "Creating sample backup..."

  echo "Kiểm tra dung lượng ổ đĩa khả dụng trước khi backup:"
  df -h . # Hiển thị dung lượng ổ đĩa khả dụng
  # Có thể bổ sung logic kiểm tra nếu dung lượng dưới ngưỡng cho phép và cảnh báo/dừng script.
  mkdir -p ./backups/logical
  
  # Create simple backup
  pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" \
    -f "./backups/logical/demo_backup_$(date +%s).sql" -F plain --no-privileges
  
  echo -e "${GREEN}✅ Backup created in backups/ directory${NC}"
  ls -lah ./backups/logical/*.sql | tail -1
}

# Demo Stage 5: Distributed (Citus - requires separate setup)
demo_stage_5() {
  echo -e "\n${BLUE}[Stage 5] Distributed Systems - Citus Lab${NC}"
  echo "Citus multi-node lab requires: docker compose -f docs/5-distributed-systems/docker-compose.citus.yml up -d"
  echo "Then run: ./docs/5-distributed-systems/run_citus_multi_node_lab.sh"
}

# Demo Stage 6: Data Warehousing
demo_stage_6() {
  echo -e "\n${BLUE}[Stage 6] Data Warehousing - 1 minute${NC}"
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" <<'EOF'
-- Materialized View (Cached Analytics)
DROP MATERIALIZED VIEW IF EXISTS sales_summary CASCADE;
CREATE MATERIALIZED VIEW sales_summary AS
  SELECT month, SUM(amount) as total FROM sales GROUP BY month;

SELECT 'Materialized view for fast analytics:' as demo;
SELECT * FROM sales_summary ORDER BY month;

-- Refresh when data changes
REFRESH MATERIALIZED VIEW sales_summary;
EOF
}

# Demo Stage 8: Vector Search
demo_stage_8() {
  echo -e "\n${BLUE}[Stage 8] Modern Ecosystem - Vector Search${NC}"
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" <<'EOF'
-- Check if pgvector extension is available
CREATE EXTENSION IF NOT EXISTS vector;

DROP TABLE IF EXISTS demo_embeddings CASCADE;
CREATE TABLE demo_embeddings (
    id INT PRIMARY KEY,
    text VARCHAR(255),
    embedding VECTOR(3)
);

INSERT INTO demo_embeddings VALUES
  (1, 'hello world', '[0.1, 0.2, 0.3]'),
  (2, 'hello there', '[0.1, 0.2, 0.31]'),
  (3, 'goodbye world', '[0.5, 0.6, 0.7]');

-- Find similar embeddings (cosine distance)
SELECT text, embedding
FROM demo_embeddings
ORDER BY embedding <=> '[0.1, 0.2, 0.3]'::VECTOR(3)
LIMIT 2;
EOF
}

# Main execution
check_pg

case $DEMO_STAGE in
  0)
    demo_stage_0
    ;;
  1)
    demo_stage_1
    ;;
  3)
    demo_stage_3
    ;;
  4)
    demo_stage_4
    ;;
  5)
    demo_stage_5
    ;;
  6)
    demo_stage_6
    ;;
  8)
    demo_stage_8
    ;;
  all)
    demo_stage_0
    demo_stage_1
    demo_stage_2
    demo_stage_3
    demo_stage_4
    # Stage 7 (Observability) is not part of this quick demo.
    # Refer to their respective docs/ for detailed labs.
    demo_stage_6
    demo_stage_8
    ;;
  *)
    echo "Usage: $0 [0|1|2|3|4|5|6|8|all]"
    exit 1
    ;;
esac

echo -e "\n${GREEN}✅ Demo completed!${NC}"
echo "📚 Read more in docs/ or check SETUP.md for full learning paths"
