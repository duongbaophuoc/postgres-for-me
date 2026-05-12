# Stage 7: Observability, SRE & Incident Engineering
## Giai đoạn 7: Giám sát, SRE & Xử lý sự cố

### 📊 Monitoring / Giám sát
- **Key Metrics**: Transaction throughput, Rollback rates, Cache hit ratio. / Các chỉ số quan trọng: Tốc độ giao dịch, tỷ lệ rollback, tỷ lệ trúng cache.
- **pg_stat_activity**: Active session monitoring. / Giám sát phiên hoạt động.
- **pg_stat_statements**: Finding the slowest queries. / Tìm kiếm các truy vấn chậm nhất.
- **pg_locks**: Lock diagnostics and blocking sessions. / Chẩn đoán khóa và phiên bị chặn.
- **auto_explain**: Capturing query plans for slow statements. / Thu thập kế hoạch truy vấn cho câu lệnh chậm.
- **Prometheus Exporters**: Metrics collection for monitoring. / Thu thập số liệu để giám sát.
- **Grafana Dashboards**: Visualizing PostgreSQL health. / Trực quan hóa sức khỏe của PostgreSQL.
- **WAL Metrics**: Replication visibility and log activity. / Giám sát WAL và sao chép.
- **Bloat Monitoring**: Detecting heap/index growth. / Phát hiện phình to dữ liệu.
- **Autovacuum Metrics**: Maintenance health indicators. / Chỉ số sức khỏe autovacuum.

### 🚨 Incident Engineering / Xử lý sự cố
- **Lock Contention**: Debugging blocking queries. / Gỡ lỗi các truy vấn gây nghẽn.
- **Replication Lag**: Identifying bottlenecks in log shipping. / Xác định nghẽn cổ chai trong quá trình truyền log.
- **WAL Explosion**: Handling sudden WAL volume growth. / Xử lý tình trạng WAL bùng nổ.
- **Transaction Wraparound**: Preventing catastrophic XID wraparound. / Ngăn ngừa tràn ID giao dịch.
- **Vacuum Failures**: Diagnosing MVCC cleanup problems. / Chẩn đoán lỗi dọn dẹp MVCC.
- **Query Regression**: Investigating performance regressions. / Điều tra suy giảm hiệu năng truy vấn.
- **Failover Drills**: Practicing recovery scenarios. / Diễn tập chuyển đổi dự phòng.

### 📈 Capacity Planning / Lập kế hoạch năng lực
- **CPU Sizing**: Estimating workload CPU needs. / Ước lượng nhu cầu CPU.
- **Shared Buffers Sizing**: Memory planning for cache. / Lập kế hoạch bộ nhớ đệm.
- **WAL Capacity Planning**: Sizing WAL storage for recovery. / Quy hoạch dung lượng WAL.
- **IOPS Forecasting**: Storage performance planning. / Dự báo hiệu năng lưu trữ.
- **Connection Scaling**: Planning pooled connections and limits. / Lập kế hoạch mở rộng kết nối.

---
*Next: [Stage 8 - Modern Ecosystem](../8-modern-ecosystem/README.md)*
