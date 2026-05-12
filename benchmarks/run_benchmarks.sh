#!/bin/bash
# pgbench stress test script for commerce_db

# 1. Initialize data (Scale Factor 100 = ~1.5GB)
echo "Initializing pgbench data..."
pgbench -i -s 100 -U engineer -d commerce_db

# 2. Run Stress Test
# -c: clients, -j: threads, -T: duration (sec), -P: progress report
echo "Starting Read-Write Stress Test (600s)..."
pgbench -c 20 -j 4 -T 600 -P 10 -U engineer -d commerce_db > benchmark_results.log

# 3. Run Read-Only Stress Test
echo "Starting Read-Only Stress Test..."
pgbench -c 50 -j 8 -S -T 300 -P 10 -U engineer -d commerce_db >> benchmark_results.log

echo "Benchmark completed. Results saved in benchmark_results.log"
