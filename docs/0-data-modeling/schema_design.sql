-- Stage 0: Data Modeling Examples
-- Entities: Users, Orders, and Multi-tenant partitioning

-- 1. UUID v7 for distributed primary keys
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Exclusion Constraint (Prevent overlapping schedules)
DROP TABLE IF EXISTS room_reservations CASCADE;
DROP TABLE IF EXISTS products_pricing CASCADE;

CREATE TABLE room_reservations (
    room_id INT,
    booking_period TSRANGE,
    EXCLUDE USING gist (room_id WITH =, booking_period WITH &&)
);

-- 3. Generated Columns
CREATE TABLE products_pricing (
    id SERIAL PRIMARY KEY,
    price_net DECIMAL,
    tax_rate DECIMAL DEFAULT 0.1,
    price_gross DECIMAL GENERATED ALWAYS AS (price_net * (1 + tax_rate)) STORED
);
