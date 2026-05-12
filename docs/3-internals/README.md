# Stage 3: PostgreSQL Internals & Performance
## Giai đoạn 3: Cấu trúc bên trong & Tối ưu hiệu năng

### 1. Storage Architecture / Kiến trúc lưu trữ
- **Heap & Pages**: PostgreSQL stores data in 8KB blocks. / PostgreSQL lưu trữ dữ liệu trong các khối 8KB.
- **Page Structure**: The layout of tuples inside blocks. / Cấu trúc của bản ghi trong khối.
- **Tuple Layout**: Internal row on-disk format. / Định dạng dòng nội bộ trên đĩa.
- **TOAST (The Oversized-Attribute Storage Technique)**: Handling large column values. / Kỹ thuật lưu trữ các thuộc tính kích thước lớn.
- **FSM (Free Space Map)**: Tracking free space in heap pages. / Bản đồ không gian trống.
- **Visibility Map**: Optimizing VACUUM and index-only scans. / Tối ưu VACUUM và quét chỉ mục.
- **Shared Buffers**: PostgreSQL's memory cache. / Bộ nhớ đệm của PostgreSQL.
- **Buffer Manager**: Page replacement and dirty page handling. / Quản lý trang và xử lý trang bẩn.
- **Checkpoints**: Coordinating flushes to durable storage. / Điều phối ghi dữ liệu bền vững.
- **Background Writer**: Cleaning dirty pages in the background. / Xử lý trang bẩn ở nền.

### 2. MVCC & Vacuum / Đa phiên bản & Dọn dẹp
- **MVCC (Multi-Version Concurrency Control)**: How Postgres handles concurrent access without locking. / Cách Postgres xử lý truy cập đồng thời mà không cần khóa.
- **Dead Tuples**: Rows that are no longer visible but still occupy space. / Các bản ghi không còn hiển thị nhưng vẫn chiếm dung lượng.
- **HOT Updates**: Heap-only updates that avoid index writes. / Cập nhật chỉ trên heap, tránh ghi chỉ mục.
- **VACUUM / Autovacuum**: Reclaiming space from dead tuples. / Thu hồi không gian từ các dead tuples.
- **Freeze Operations**: Protecting tuples from XID wraparound. / Bảo vệ tuple khỏi tràn ID giao dịch.
- **Transaction ID Wraparound**: A critical risk when Autovacuum can't keep up. / Rủi ro nghiêm trọng khi Autovacuum không theo kịp tốc độ giao dịch.
- **xmin/xmax**: Visibility metadata for tuple versions. / Metadata tầm nhìn của tuple.
- **Long Transactions**: MVCC pressure from long-running sessions. / Áp lực MVCC từ phiên kéo dài.
- **Bloat**: Heap and index growth from dead tuples. / Phình to của heap và chỉ mục.

### 3. Query Planner / Bộ lập lịch truy vấn
- **EXPLAIN ANALYZE**: The primary tool for query diagnosis. / Công cụ chính để chẩn đoán truy vấn.
- **Join Algorithms**: Nested Loop, Hash Join, Merge Join. / Các thuật toán Join.
- **Statistics**: How the planner decides which path to take. / Cách bộ lập lịch quyết định lộ trình thực thi.
- **Histograms**: Data distribution for selectivity estimates. / Phân phối dữ liệu cho ước lượng.
- **Cardinality Estimation**: Predicting result size for plan costs. / Ước lượng kích thước kết quả cho chi phí.
- **ANALYZE**: Collecting statistics that guide the planner. / Thu thập thống kê cho bộ lập kế hoạch.

### 4. Indexing Deep Dive / Đi sâu vào Chỉ mục
- **B-Tree**: General purpose indexing. / Chỉ mục phổ thông.
- **GIN Index**: JSONB and full-text indexing. / Chỉ mục GIN cho JSONB và tìm kiếm văn bản.
- **GiST**: Geospatial and custom indexing. / Chỉ mục GiST cho dữ liệu không gian.
- **BRIN**: Large table optimization. / Tối ưu bảng lớn.
- **Expression Indexes**: Indexes on computed expressions. / Chỉ mục trên biểu thức.
- **Partial Indexes**: Conditional indexes for filtered workloads. / Chỉ mục một phần có điều kiện.
- **Covering Indexes**: INCLUDE optimization for index-only scans. / Tối ưu INCLUDE cho quét chỉ mục.

## Lab Practice / Thực hành lab
- Use `docs/3-internals/lab_practice.md` for a hands-on exercise.
- Run the automated lab script `docs/3-internals/run_lab.sh` to provision data, measure bloat, and perform planner diagnostics.
- Practice creating MVCC bloat, running `EXPLAIN ANALYZE`, and measuring `VACUUM` effects.
- Combine `inspect_storage.sql` with planner diagnostics.

---
*Next: [Stage 4 - Operations](../4-operations/README.md)*
*Tiếp theo: [Giai đoạn 4 - Vận hành](../4-operations/README.md)*
