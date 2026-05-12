# Stage 4: Production Operations & Reliability
## Giai đoạn 4: Vận hành Production & Độ tin cậy

### 1. High Availability (HA) / Tính sẵn sàng cao
- **Streaming Replication**: Physical log-based replication. / Sao chép vật lý dựa trên log.
- **Logical Replication**: Row-level selective replication. / Sao chép logic theo hàng.
- **WAL Shipping**: Shipping logs for recovery and standby. / Vận chuyển WAL cho phục hồi.
- **Replication Slots**: Preserving WAL for replicas. / Giữ WAL cho các bản sao.
- **Hot Standby**: Read-only replicas for query offloading. / Bản sao chỉ đọc để giảm tải truy vấn.
- **Synchronous Replication**: Strong consistency replication. / Sao chép đồng bộ đảm bảo nhất quán.
- **Asynchronous Replication**: Higher throughput replication. / Sao chép không đồng bộ tối ưu hiệu suất.
- **Patroni**: The gold standard for PostgreSQL HA orchestration. / Tiêu chuẩn vàng để điều phối HA cho PostgreSQL.
- **repmgr**: Replication management tooling. / Công cụ quản lý sao chép.
- **Failover & Switchover**: Moving the primary role between nodes. / Chuyển đổi vai trò Primary giữa các node.
- **Timeline Management**: Tracking recovery lineage and history. / Quản lý dòng thời gian phục hồi.

### 2. Backup & Disaster Recovery (DR) / Sao lưu & Phục hồi sau thảm họa
- **pg_basebackup**: Physical backup of the entire cluster. / Sao lưu vật lý toàn bộ cụm CSDL.
- **WAL Archiving**: Shipping WAL segments to remote storage (S3/GCS). / Chuyển các phân đoạn WAL tới bộ lưu trữ từ xa.
- **PITR (Point-In-Time Recovery)**: Restoring to a specific microsecond. / Khôi phục dữ liệu đến một thời điểm chính xác.
- **Backup Validation**: Testing restores to verify backups. / Kiểm thử phục hồi để xác thực sao lưu.
- **Disaster Recovery**: Regional recovery and failover planning. / Phục hồi khu vực và lập kế hoạch khẩn cấp.
- **WAL-G**: Cloud-native WAL backup and restore. / Sao lưu và phục hồi WAL cho đám mây.

### 3. Security / Bảo mật
- **RBAC (Role-Based Access Control)**: Managing users and privileges. / Quản lý người dùng và quyền hạn.
- **Row-Level Security (RLS)**: Enforcing data isolation at the row level. / Áp dụng cách ly dữ liệu ở cấp độ dòng.
- **pg_hba.conf**: Authentication rules and host access. / Quy tắc xác thực và truy cập máy chủ.
- **SSL/TLS**: Secure client/server transport. / Mã hóa đường truyền an toàn.
- **SCRAM Authentication**: Modern password authentication. / Xác thực mật khẩu hiện đại.
- **SECURITY DEFINER**: Controlled privilege escalation. / Leo thang quyền hạn có kiểm soát.
- **Secrets Management**: Managing credentials and secrets securely. / Quản lý thông tin xác thực an toàn.

## Lab Practice / Thực hành lab
- Use `docs/4-operations/lab_practice.md` to practice backups, replication, and security checks.
- Run the automated lab script `docs/4-operations/run_lab.sh` to execute backup validation, analyze maintenance, and inspect security settings.
- Run `docs/4-operations/restore_lab.sh` to validate restore from the latest logical backup.
- Run `docs/4-operations/wal_pitr_restore_lab.sh` to practice WAL archiving and point-in-time recovery using a base backup and archive WAL segments.
- Validate backup automation with `ops_tasks.sh`.
- Simulate failover and inspect WAL/replication state.

---
*Next: [Stage 5 - Distributed Systems](../5-distributed-systems/README.md)*
*Tiếp theo: [Giai đoạn 5 - Hệ thống phân tán](../5-distributed-systems/README.md)*
