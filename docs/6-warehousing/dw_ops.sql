-- Stage 6: Data Warehousing & Analytics
-- Fact and Dimension Table Operations

-- 1. Aggregate Table for Dashboard Performance
CREATE TABLE daily_sales_summary AS
SELECT 
    date_trunc('day', created_at) AS sale_day,
    product_key,
    SUM(sales_amount) AS total_revenue,
    COUNT(DISTINCT customer_key) AS unique_customers
FROM fact_sales
GROUP BY 1, 2;

-- 2. Materialized View for Expensive Reports
CREATE MATERIALIZED VIEW monthly_category_report AS
SELECT 
    EXTRACT(MONTH FROM date_key) as month,
    p.category,
    SUM(sales_amount) as revenue
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY 1, 2;

-- Refresh logic
-- REFRESH MATERIALIZED VIEW monthly_category_report;

-- 3. SCD Type 2 Update Logic (Historical Tracking)
-- 1. Close current record
-- UPDATE dim_customer SET effective_end_date = CURRENT_DATE, is_current = false WHERE customer_id = ...;
-- 2. Insert new record
-- INSERT INTO dim_customer (customer_id, name, region, effective_start_date, is_current) VALUES (...);
