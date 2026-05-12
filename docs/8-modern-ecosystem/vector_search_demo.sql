-- Stage 8: Modern Ecosystem & AI
-- Vector Search and Time-Series Hypertables

-- 1. pgvector: Similarity Search with HNSW
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE item_embeddings (
    id SERIAL PRIMARY KEY,
    item_name TEXT,
    embedding VECTOR(3) -- Simplified 3D vector for demo
);

INSERT INTO item_embeddings (item_name, embedding) VALUES
('PostgreSQL Book', '[0.1, 0.5, 0.9]'),
('AI Handbook', '[0.9, 0.4, 0.1]');

-- Find nearest neighbors using Cosine Distance
SELECT item_name FROM item_embeddings 
ORDER BY embedding <=> '[0.1, 0.4, 0.8]' LIMIT 5;

-- 2. TimescaleDB (if installed): Create Hypertable
-- SELECT create_hypertable('conditions', 'time');
