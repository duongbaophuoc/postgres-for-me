# Stage 6: Data Warehousing & Analytics Engineering
## Giai đoạn 6: Kho dữ liệu & Kỹ thuật phân tích

### 🏗️ Analytical Modeling / Mô hình phân tích
- **OLTP vs OLAP**: Workload separation and architecture. / Phân tách tải OLTP và OLAP.
- **Star & Snowflake Schemas**: Designing for fast aggregations. / Thiết kế tối ưu cho các tác vụ tổng hợp.
- **Fact vs Dimension Tables**: The building blocks of a warehouse. / Các thành phần cốt lõi của kho dữ liệu.
- **SCD Type 1/2/3**: Handling slowly changing dimensions. / Xử lý các thay đổi chiều theo thời gian.
- **Aggregate Tables**: Precomputed aggregates for reporting. / Bảng tổng hợp tính trước cho báo cáo.
- **Data Marts**: Department-focused analytics stores. / Kho dữ liệu theo phòng ban.

### 🔄 Data Pipelines & ETL / Luồng dữ liệu & ETL
- **ETL Fundamentals**: Data extraction, transformation, and loading. / Nguyên lý ETL.
- **ELT Architectures**: Transforming data inside the warehouse. / Kiến trúc ELT.
- **Incremental Loads**: Efficient synchronization of changed data. / Tải dữ liệu thay đổi hiệu quả.
- **CDC Pipelines**: WAL-based ingestion for near real-time updates. / Thu thập dữ liệu dựa trên WAL.
- **Airflow**: Orchestrating complex data pipelines. / Điều phối các đường ống dữ liệu phức tạp.
- **dbt (Data Build Tool)**: Transforming data within the warehouse. / Công cụ chuyển đổi dữ liệu.
- **Spark Integration**: Distributed analytics and processing. / Tích hợp Spark cho phân tích phân tán.
- **Batch vs Streaming**: Choosing the right processing model. / Chọn mô hình xử lý phù hợp.

### 📊 Analytics & Reporting / Phân tích & Báo cáo
- **Materialized Views**: Cached reporting views. / Bảng ảo vật lý hóa.
- **Rollups**: Pre-aggregated summary tables. / Tổng hợp dữ liệu theo cấp.
- **Hypertables**: Time-series optimized storage. / Bảng siêu cấp cho dữ liệu chuỗi thời gian.
- **Query Acceleration**: Techniques for faster analytics. / Tăng tốc truy vấn phân tích.
- **BI Integration**: Tableau/Power BI and analytics dashboards. / Tích hợp BI.
- **KPI Systems**: Metrics engineering for business signals. / Xây dựng chỉ số KPI.

### 🤖 Data Science Infrastructure / Hạ tầng khoa học dữ liệu
- **Feature Stores**: ML feature management. / Quản lý đặc trưng ML.
- **Data Lakes**: Hybrid analytics architectures. / Kiến trúc dữ liệu lai.
- **Vector Embeddings**: AI-ready feature representations. / Biểu diễn vector cho AI.
- **ML Data Pipelines**: Training workflow data flows. / Luồng dữ liệu cho huấn luyện ML.
- **Data Validation**: Ensuring data quality for analytics. / Kiểm tra chất lượng dữ liệu.

---
*Next: [Stage 7 - Observability](../7-observability/README.md)*
