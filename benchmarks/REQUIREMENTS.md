# Benchmarking & Performance Testing Requirements
## Yêu cầu Kỹ thuật Kiểm thử hiệu năng (Benchmarking)

### 🎯 Objective / Mục tiêu
- Measure PostgreSQL performance under concurrent load.
- Đo lường hiệu năng Postgres dưới tải đồng thời.

### 🛠️ Technical Tool / Công cụ
- **pgbench**: The standard PostgreSQL benchmarking tool.

---

### 💻 pgbench Test Script
File: `run_stress_test.sh`

```bash
#!/bin/bash
# Initialize pgbench with scale factor 100 (~1.5GB data)
pgbench -i -s 100 -U postgres commerce_db

# Run stress test:
# -c 50: 50 concurrent clients
# -j 4: 4 worker threads
# -T 600: Run for 600 seconds
# -P 10: Print progress every 10 seconds
pgbench -c 50 -j 4 -T 600 -P 10 -U postgres commerce_db > benchmark_results.log
```

### 📈 Metrics to Monitor
- **TPS (Transactions Per Second)**.
- **Latency (ms)**: Average and 95th percentile.
- **Disk I/O**: Utilization and Wait times.
