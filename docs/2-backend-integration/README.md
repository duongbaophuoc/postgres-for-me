# Stage 2: Backend Integration & SQL Engineering
## Giai đoạn 2: Tích hợp Backend & Kỹ thuật SQL

### 🔌 Application Integration / Tích hợp ứng dụng
- **Connection Management**: Persistent vs transient connections. / Quản lý kết nối bền vững vs tạm thời.
- **ORM best practices**: Avoiding N+1 problems. / Các thực hành tốt nhất với ORM để tránh lỗi N+1.
- **Prepared Statements**: Security and performance. / Câu lệnh chuẩn bị sẵn để bảo mật và tăng hiệu năng.
- **Hibernate/JPA**: Java ORM patterns. / Mẫu ORM cho Java.
- **SQLAlchemy**: Python ORM. / ORM cho Python.
- **Prisma**: Type-safe ORM for Node.js. / ORM kiểu an toàn cho Node.js.
- **Sequelize**: Node.js integration. / Tích hợp ORM cho Node.js.
- **Entity Framework**: .NET ORM integration. / Tích hợp ORM cho .NET.

### 🔄 Transactions & Concurrency / Giao dịch & Đồng thời
- **Isolation Levels**: 
    - `Read Committed` (Default)
    - `Repeatable Read`
    - `Serializable`
- **Locking Strategies**: Optimistic vs Pessimistic locking. / Chiến lược khóa lạc quan vs bi quan.
- **Deadlock Detection**: Understanding how Postgres resolves conflicts. / Hiểu cách Postgres giải quyết xung đột khóa.
- **Transaction Boundaries**: Designing clear start/end points for work. / Thiết kế ranh giới giao dịch rõ ràng.

### ⚡ Query Engineering / Kỹ thuật truy vấn
- **Batch Operations**: Bulk inserts and updates. / Thao tác hàng loạt.
- **Pagination Strategies**: Offset vs cursor. / Chiến lược phân trang.
- **LATERAL JOINs**: Advanced row-by-row query patterns. / Mẫu truy vấn nâng cao theo hàng.
- **Window Frames**: ROWS vs RANGE. / Khung cửa sổ trong phân tích.
- **Query Rewriting**: Planner-friendly SQL rewrites. / Viết lại SQL để phù hợp bộ lập kế hoạch.

### 🏗️ Architecture Patterns / Mô hình kiến trúc
- **Read/Write Splitting**: Routing traffic to replicas. / Phân tách luồng Đọc/Ghi.
- **CQRS**: Read/write segregation. / Tách biệt Đọc/Ghi.
- **Event Sourcing**: Immutable event history. / Lịch sử sự kiện bất biến.
- **Idempotency**: Ensuring reliable retries in distributed systems. / Đảm bảo tính nhất quán khi thử lại.
- **Retry Patterns**: Failure handling and backoff. / Mẫu thử lại và giảm áp lực.
- **Distributed Transactions**: Saga and two-phase commit patterns. / Giao dịch phân tán.

---
*Next: [Stage 3 - Internals](../3-internals/README.md)*
