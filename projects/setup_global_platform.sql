-- Project: Global E-commerce Infrastructure Setup
-- Implementing Multi-region Sharding and Analytics Ready Schema

-- 1. Citus Sharding Setup (Logical representation)
-- Assuming Citus extension is installed
-- SELECT create_distributed_table('orders', 'customer_id');

-- 2. Star Schema implementation for Analytics
CREATE SCHEMA IF NOT EXISTS warehouse;

CREATE TABLE warehouse.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id UUID UNIQUE,
    full_name TEXT,
    region TEXT,
    is_current BOOLEAN DEFAULT true,
    effective_start_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE warehouse.fact_orders (
    order_key SERIAL PRIMARY KEY,
    order_id UUID,
    customer_key INT REFERENCES warehouse.dim_customer(customer_key),
    order_date_key INT,
    total_amount DECIMAL(18,2),
    tax_amount DECIMAL(18,2)
);

-- 3. Partitioning by Month for the Fact table
CREATE TABLE warehouse.fact_orders_y2024m05 
PARTITION OF warehouse.fact_orders
FOR VALUES FROM (20240501) TO (20240601);

-- 4. View for Global Dashboard
CREATE VIEW global_sales_overview AS
SELECT 
    c.region,
    SUM(f.total_amount) as total_sales
FROM warehouse.fact_orders f
JOIN warehouse.dim_customer c ON f.customer_key = c.customer_key
GROUP BY 1;
