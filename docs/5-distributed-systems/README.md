# Stage 5: Distributed PostgreSQL Systems
## Giai đoạn 5: Hệ thống PostgreSQL phân tán

### 🌐 Scaling Out / Mở rộng quy mô
- **Horizontal Scaling**: Scale-out systems with multiple nodes. / Mở rộng theo chiều ngang với nhiều node.
- **Table Partitioning**: Dividing large tables into smaller chunks. / Chia nhỏ bảng lớn thành các phần nhỏ hơn.
    - Range, List, and Hash partitioning.
- **Partition Pruning**: Planner optimization for partitioned tables. / Tối ưu bộ lập kế hoạch cho bảng phân vùng.
- **Citus**: Transforming Postgres into a distributed database. / Biến Postgres thành CSDL phân tán với Citus.
- **Sharding**: Distributing data across nodes. / Phân mảnh dữ liệu trên nhiều node.
- **Two-Phase Commit (2PC)**: Ensuring consistency across nodes. / Đảm bảo tính nhất quán giữa các node.
- **CAP Theorem**: Understanding distributed trade-offs. / Hiểu các đánh đổi trong hệ thống phân tán.
- **Eventual Consistency**: Relaxed consistency for higher availability. / Nhất quán cuối cùng để tăng tính khả dụng.
- **Read Scaling**: Replica architectures for read-heavy workloads. / Kiến trúc bản sao cho tải đọc cao.
- **Multi-region Deployments**: Global distributed database patterns. / Mẫu triển khai phân tán đa vùng.

### 📡 CDC (Change Data Capture) / Bắt giữ dữ liệu thay đổi
- **Logical Decoding**: Streaming database changes in real-time. / Truyền luồng thay đổi CSDL trong thời gian thực.
- **Debezium**: Integration with Kafka for event-driven architectures. / Tích hợp với Kafka cho kiến trúc hướng sự kiện.
- **Kafka Integration**: Streaming pipelines with Kafka. / Đường ống dữ liệu streaming với Kafka.
- **Outbox Pattern**: Ensuring atomicity between DB updates and event publishing. / Đảm bảo tính nguyên tử giữa cập nhật DB và phát hành sự kiện.
- **LISTEN / NOTIFY**: Lightweight PostgreSQL messaging. / Cơ chế nhắn tin nhẹ của PostgreSQL.
- **Event Streams**: Building real-time data flows. / Xây dựng luồng dữ liệu thời gian thực.

### ⚙️ Connection Infrastructure / Hạ tầng kết nối
- **Process-per-Connection**: PostgreSQL backend architecture. / Kiến trúc backend mỗi kết nối một tiến trình.
- **Shared Memory**: Backend coordination and caching. / Điều phối backend và bộ nhớ chung.
- **PgBouncer**: Lightweight connection pooler. / Trình quản lý kết nối gọn nhẹ.
- **Transaction Pooling**: Handling thousands of clients efficiently. / Quản lý hàng ngàn kết nối đồng thời một cách hiệu quả.
- **Session Pooling**: Managing session state in pooled environments. / Quản lý trạng thái phiên trong môi trường gom nhóm.

## Lab Practice / Thực hành lab
- Use `docs/5-distributed-systems/lab_practice.md` to practice partitioning, logical replication, and connection pooling.
- Run the automated lab script `docs/5-distributed-systems/run_lab.sh` to create partitioned tables and validate planner pruning.
- Use `docs/5-distributed-systems/citus_replication_lab.sh` to walk through logical replication and Citus-driven distribution.
- Use `docs/5-distributed-systems/run_citus_multi_node_lab.sh` and `docs/5-distributed-systems/docker-compose.citus.yml` to launch a true multi-node Citus cluster locally.
- Use `docs/5-distributed-systems/run_citus_k8s_lab.sh` and `docs/5-distributed-systems/citus-k8s.yaml` to launch a Kubernetes-based Citus multi-node lab with pod/service registration.
- Run `partition_setup.sql` and validate partition pruning.
- Explore multi-region replication patterns and eventual consistency trade-offs.

---
*Next: [Stage 6 - Warehousing](../6-warehousing/README.md)*
