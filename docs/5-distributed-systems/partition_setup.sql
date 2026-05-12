-- Stage 5: Distributed Systems & Partitioning
-- Declarative Partitioning by Range

-- Clean up for idempotency
DROP TABLE IF EXISTS measurement CASCADE;
DROP PUBLICATION IF EXISTS all_tables;
DROP SUBSCRIPTION IF EXISTS sub_all_tables;

-- 1. Create Parent Table
CREATE TABLE measurement (
    city_id         int not null,
    logdate         date not null,
    peaktemp        int,
    unitsales       int
) PARTITION BY RANGE (logdate);

-- 2. Create Partitions
CREATE TABLE measurement_y2023m01 PARTITION OF measurement
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

CREATE TABLE measurement_y2023m02 PARTITION OF measurement
    FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');

-- 3. Logical Replication Setup
-- On Publisher:
-- CREATE PUBLICATION all_tables FOR ALL TABLES;

-- On Subscriber:
-- CREATE SUBSCRIPTION sub_all_tables CONNECTION 'host=publisher_ip dbname=prod_db user=replicator password=secret' PUBLICATION all_tables;
