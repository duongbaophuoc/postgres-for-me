# ETL & Data Pipeline Engineering Requirements
## Yêu cầu Kỹ thuật ETL & Đường ống Dữ liệu

### 🎯 Objective / Mục tiêu
- Implement an ELT (Extract-Load-Transform) pipeline using PostgreSQL and dbt.
- Triển khai đường ống ELT sử dụng PostgreSQL và dbt.

### 🛠️ Technical Stack / Công nghệ
- **dbt-postgres**: For SQL-based transformations.
- **Airflow**: For orchestration.
- **PostgreSQL**: As the target Data Warehouse.

### 📜 Implementation Guide / Hướng dẫn triển khai
1. Configure `profiles.yml` for dbt connection.
2. Define sources in `src_ecommerce.yml`.
3. Create models for Star Schema (Fact & Dimensions).

---

### 💻 Sample dbt Model (Transform)
File: `models/marts/fct_sales.sql`

```sql
{{ config(materialized='incremental', unique_key='sales_key') }}

WITH raw_orders AS (
    SELECT * FROM {{ source('ecommerce', 'orders') }}
    {% if is_incremental() %}
    WHERE created_at > (SELECT max(created_at) FROM {{ this }})
    {% endif %}
),
order_items AS (
    SELECT * FROM {{ source('ecommerce', 'order_items') }}
)

SELECT
    o.order_id,
    o.user_id as customer_key,
    oi.product_id as product_key,
    o.created_at as date_key,
    oi.quantity,
    (oi.quantity * oi.price_at_purchase) as sales_amount
FROM raw_orders o
JOIN order_items oi ON o.order_id = oi.order_id
```
