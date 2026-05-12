-- ========================================================
-- DATABASE: vector_search_db (AI/RAG)
-- PURPOSE: AI retrieval and Vector Embedding storage
-- REQUIREMENTS: pgvector extension, HNSW indexing
-- ========================================================

-- Enable the pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Clean up for idempotency
DROP TABLE IF EXISTS embeddings CASCADE;
DROP TABLE IF EXISTS documents CASCADE;

-- Table: documents (Nguồn tri thức)
CREATE TABLE documents (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: embeddings (Lưu trữ Vector)
CREATE TABLE embeddings (
    id BIGSERIAL PRIMARY KEY,
    document_id BIGINT REFERENCES documents(id) ON DELETE CASCADE,
    embedding VECTOR(1536), -- Dimension for OpenAI embeddings
    model_name VARCHAR(100) NOT NULL
);

-- HNSW Index for fast similarity search
-- Requirements: m=16, ef_construction=64 for balance between speed/accuracy
CREATE INDEX ON embeddings USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- Search function (Similarity search)
CREATE OR REPLACE FUNCTION match_documents (
  query_embedding VECTOR(1536),
  match_threshold FLOAT,
  match_count INT
)
RETURNS TABLE (
  id BIGINT,
  content TEXT,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id,
    d.content,
    (1 - (e.embedding <=> query_embedding))::FLOAT AS similarity
  FROM embeddings e
  JOIN documents d ON e.document_id = d.id
  -- Optimization: Use distance operator directly for index scanning
  WHERE (e.embedding <=> query_embedding) < (1 - match_threshold)
  ORDER BY e.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;
