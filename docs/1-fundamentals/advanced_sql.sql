-- Stage 1: PostgreSQL Fundamentals
-- Complex Data Types and Analytical Queries

-- 1. JSONB Operations & Indexing
DROP TABLE IF EXISTS product_metadata CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS occupancy CASCADE;

CREATE TABLE product_metadata (
    id SERIAL PRIMARY KEY,
    details JSONB
);

INSERT INTO product_metadata (details) VALUES 
('{"brand": "Logitech", "tags": ["wireless", "gaming"], "specs": {"dpi": 16000}}');

-- Fast JSONB Search
SELECT * FROM product_metadata WHERE details @> '{"brand": "Logitech"}';

-- 2. Window Functions Example
SELECT 
    name, 
    price, 
    AVG(price) OVER (PARTITION BY category) as avg_cat_price
FROM products;

-- 3. Range Types
CREATE TABLE occupancy (
    room_id INT,
    during DATERANGE
);
INSERT INTO occupancy VALUES (101, '[2024-01-01, 2024-01-05)');
