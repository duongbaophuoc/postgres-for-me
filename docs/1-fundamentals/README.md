# Stage 1: PostgreSQL Fundamentals
## Giai đoạn 1: Nền tảng PostgreSQL

### 🛠️ Environment & Tooling / Môi trường & Công cụ
- **PostgreSQL Setup**: Installation and initial configuration. / Cài đặt và cấu hình ban đầu.
- **psql**: The powerful CLI. / Giao diện dòng lệnh mạnh mẽ.
- **pgAdmin / DBeaver**: GUI clients for management. / Công cụ quản trị giao diện đồ họa.
- **Docker PostgreSQL**: Containerized development and testing. / Phát triển và kiểm thử với container.
- **postgresql.conf**: The heart of configuration. / File cấu hình cốt lõi của PostgreSQL.

### 📚 Advanced SQL Basics / SQL Nâng cao
- **DDL**: CREATE, ALTER, DROP. / Định nghĩa cấu trúc dữ liệu.
- **DML**: INSERT, UPDATE, DELETE, SELECT. / Thao tác dữ liệu.
- **RETURNING**: PostgreSQL-specific DML return values. / Trả về dữ liệu sau thao tác.
- **JOINs**: Relational querying patterns. / Các mẫu truy vấn quan hệ.
- **Aggregation**: GROUP BY & HAVING. / Tổng hợp dữ liệu.
- **Data Types**: Beyond Integer and Text.
    - `JSONB`: Efficient semi-structured data storage. / Lưu trữ dữ liệu bán cấu trúc hiệu quả.
    - `ARRAY`: Storing lists directly in columns. / Lưu trữ danh sách trực tiếp trong cột.
    - `RANGE`: Handling time and numeric ranges. / Xử lý dải thời gian và số liệu.
- **Window Functions**: `RANK()`, `LEAD()`, `LAG()`, `OVER()`.
- **Recursive CTEs**: Handling hierarchical data (Org charts, trees). / Xử lý dữ liệu phân cấp.
- **Views**: Logical abstractions. / Bảng ảo.
- **Materialized Views**: Caching complex query results. / Lưu bộ nhớ đệm cho kết quả truy vấn phức tạp.

### 🧩 PostgreSQL-Specific Features / Các tính năng đặc thù
- **JSONB**: Semi-structured data storage. / Dữ liệu bán cấu trúc.
- **ARRAY**: Native array support. / Hỗ trợ mảng gốc.
- **RANGE**: Temporal and numeric ranges. / Dải thời gian và số.
- **ENUM Types**: Domain modeling. / Mô hình hóa miền dữ liệu.
- **HSTORE**: Key-value storage. / Lưu trữ dạng khóa-giá trị.
- **Extensions**: PostgreSQL ecosystem modules. / Các tiện ích mở rộng của PostgreSQL.

---
*Next: [Stage 2 - Backend Integration](../2-backend-integration/README.md)*
