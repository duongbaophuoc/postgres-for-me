# Stage 0: Data Modeling & Relational Architecture
## Giai đoạn 0: Thiết kế mô hình dữ liệu & Kiến trúc quan hệ

### 1. Relational Modeling / Mô hình hóa quan hệ
- **ERD (Entity Relationship Diagram)**: The blueprint of your database. / Bản thiết kế sơ đồ thực thể quan hệ.
- **Normalization (1NF -> BCNF)**: Reducing redundancy. / Giảm thiểu sự dư thừa dữ liệu.
- **Denormalization**: Improving read performance at the cost of write complexity. / Cải thiện hiệu suất đọc bằng cách chấp nhận độ phức tạp khi ghi.
- **Cardinality**: One-to-many, many-to-many relationships. / Mối quan hệ 1-n, n-n.
- **OLTP vs OLAP**: Transactional systems vs analytical systems. / Hệ thống giao dịch so với hệ thống phân tích.
- **Fact & Dimension Tables**: Star schema building blocks. / Các bảng sự kiện và bảng chiều trong sơ đồ sao.
- **Slowly Changing Dimensions**: Tracking dimension history. / Theo dõi lịch sử thay đổi chiều.
- **Surrogate Keys**: Warehouse-friendly identifiers. / Khóa thay thế cho thiết kế kho dữ liệu.
- **UUID v7**: Distributed identifier strategy. / Chiến lược định danh phân tán.
- **Multi-tenant Architecture**: Shared vs isolated models. / Kiến trúc đa người thuê chia sẻ hoặc cô lập.
- **Hierarchical Data**: Recursive modeling for trees and graphs. / Mô hình hóa dữ liệu phân cấp.
- **Temporal Data Modeling**: Historical and time-aware systems. / Mô hình hóa dữ liệu theo thời gian.

### 2. Integrity & Constraints / Toàn vẹn & Ràng buộc
- **Primary Keys**: Unique identity. / Định danh duy nhất.
- **Foreign Keys**: Referential integrity. / Toàn vẹn tham chiếu.
- **CHECK Constraints**: Business logic at the DB level. / Logic nghiệp vụ tại tầng CSDL.
- **Exclusion Constraints**: Useful for scheduling (overlapping ranges). / Hữu ích cho việc lập lịch (tránh trùng lặp dải dữ liệu).
- **Partial Indexes**: Conditional indexing for filtered workloads. / Chỉ mục có điều kiện.
- **Generated Columns**: Computed values stored or virtualized in SQL. / Cột tính toán tự động.

---
*Next: [Stage 1 - Fundamentals](../1-fundamentals/README.md)*
*Tiếp theo: [Giai đoạn 1 - Nền tảng](../1-fundamentals/README.md)*
