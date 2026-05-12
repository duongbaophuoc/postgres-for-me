-- ========================================================
-- DATABASE: analytics_dw (OLAP)
-- PURPOSE: Data Warehouse Star Schema for Analytics
-- REQUIREMENTS: Star Schema, Fact/Dimension Tables, SCD Type 2
-- ========================================================

-- 1. Dimension Tables (Bảng chiều)
-- Drop in reverse dependency order
DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_of_week INT,
    month INT,
    quarter INT,
    year INT,
    is_weekend BOOLEAN
);

CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id UUID, -- NK from OLTP
    name VARCHAR(255),
    email VARCHAR(255),
    region VARCHAR(100),
    effective_start_date DATE, -- For SCD Type 2
    effective_end_date DATE,
    is_current BOOLEAN
);

CREATE TABLE dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id UUID,
    sku VARCHAR(50),
    name VARCHAR(255),
    category VARCHAR(100),
    base_price DECIMAL(12, 2)
);

-- 2. Fact Table (Bảng sự thật)

CREATE TABLE fact_sales (
    sales_key BIGSERIAL PRIMARY KEY,
    date_key INT REFERENCES dim_date(date_key),
    customer_key INT REFERENCES dim_customer(customer_key),
    product_key INT REFERENCES dim_product(product_key),
    order_id UUID,
    quantity INTEGER,
    sales_amount DECIMAL(15, 2),
    tax_amount DECIMAL(15, 2),
    created_at TIMESTAMPTZ DEFAULT NOW()
) WITH (fillfactor = 100); -- Optimized for read-only inserts

-- Indices for Star Join
CREATE INDEX idx_fact_date ON fact_sales(date_key);
CREATE INDEX idx_fact_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_product ON fact_sales(product_key);
