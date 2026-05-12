# Scripts Utilities Requirements
## Yêu cầu Kỹ thuật Công cụ Tiện ích

### 🎯 Objective / Mục tiêu
- Provide utility scripts for common database operations.
- Cung cấp script tiện ích cho các hoạt động cơ sở dữ liệu phổ biến.

### 🛠️ Tools & Dependencies

**Required:**
- PostgreSQL client tools (psql, pg_basebackup, pgbench)
- Bash or POSIX shell
- Standard UNIX tools (grep, awk, sed, find)

**Optional:**
- pgBadger (for PostgreSQL log analysis)
- pg_stat_kcache (for cache hit ratio analysis)

### 📋 Available Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `check_bloat.sql` | Analyze table bloat | `psql -f check_bloat.sql` |
| Planned: `backup_automation.sh` | Automated backup with WAL archiving | `./backup_automation.sh` |
| Planned: `health_check.sh` | Cluster health monitoring | `./health_check.sh` |
| Planned: `index_maintenance.sh` | Automatic index rebuild | `./index_maintenance.sh` |

### 🚀 Usage Examples

#### Check Disk Bloat
```bash
psql -h localhost -U engineer -d production_db -f scripts/check_bloat.sql
```

Output shows:
- Table bloat percentage
- Index bloat percentage
- Estimated space wasted

### 📝 Creating Custom Utility Scripts

1. **Location**: Place in `scripts/` directory
2. **Naming**: Use descriptive names ending in `.sh` for bash, `.sql` for SQL
3. **Header**: Include comments explaining purpose and usage
4. **Error Handling**: Use `set -euo pipefail` for bash scripts
5. **Documentation**: Add usage examples in comments

Example bash script template:
```bash
#!/usr/bin/env bash
set -euo pipefail

# Script: analyze_workload.sh
# Purpose: Analyze PostgreSQL workload patterns
# Usage: ./analyze_workload.sh <hostname> <port> <database>

if [ $# -lt 3 ]; then
  echo "Usage: $0 <hostname> <port> <database>"
  exit 1
fi

HOST=$1
PORT=$2
DB=$3

psql -h "$HOST" -p "$PORT" -U engineer -d "$DB" -c "SELECT * FROM pg_stat_statements;"
```

### 📚 Related Sections
- **Backup & Recovery**: See `docs/4-operations/`
- **Maintenance Tasks**: See `docs/4-operations/ops_tasks.sh`
- **Performance Analysis**: See `docs/7-observability/`
