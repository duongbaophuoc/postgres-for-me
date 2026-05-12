# Vector Search & AI Integration Requirements
## Yêu cầu Kỹ thuật Tìm kiếm Vector & Tích hợp AI

### 🎯 Objective / Mục tiêu
- Implement vector search using pgvector extension for AI/ML workloads.
- Triển khai tìm kiếm vector bằng extension pgvector cho workload AI/ML.
- Enable RAG (Retrieval-Augmented Generation) pipelines with semantic search.

### 📋 Requirements

**Core Extensions:**
```sql
CREATE EXTENSION IF NOT EXISTS vector;  -- Vector storage & operations
CREATE EXTENSION IF NOT EXISTS pgcrypto; -- For cryptographic functions (optional)
```

**Python Dependencies** (if using embedding generation):
```bash
pip install openai langchain chromadb pgvector python-dotenv
```

### 🗂️ Schema Overview

**Tables:**
1. `documents` - Source knowledge base
2. `embeddings` - Vector embeddings (1536D for OpenAI)
3. `search_results` - Query history & ranking

**Indexes:**
- HNSW index on `embeddings.embedding` for fast similarity search
- BTree index on `documents.created_at` for temporal queries

### 🚀 Usage

#### Load Vector Search Schema
```bash
psql -h localhost -U engineer -d production_db -f vector-search/vector_search.sql
```

#### Test Similarity Search
```sql
-- Query with sample embedding (1536 dimensions)
SELECT * FROM match_documents(
  ARRAY[0.1, 0.2, -0.15, ...]::VECTOR(1536),  -- Query embedding
  0.7,    -- Similarity threshold (cosine)
  10      -- Top K results
);
```

### 🔍 Vector Search Patterns

#### 1. Semantic Search for RAG
```sql
-- Find most relevant documents for user query
WITH query_embedding AS (
  SELECT get_embedding('what is machine learning?') as embedding
)
SELECT 
  d.id,
  d.content,
  1 - (e.embedding <=> q.embedding) as similarity_score
FROM embeddings e
JOIN documents d ON e.document_id = d.id
CROSS JOIN query_embedding q
ORDER BY similarity_score DESC
LIMIT 5;
```

#### 2. Recommendation Engine
```sql
-- Find similar documents to a given document
SELECT 
  d2.id,
  d2.content,
  1 - (e1.embedding <=> e2.embedding) as similarity
FROM embeddings e1
JOIN embeddings e2 ON e1.id != e2.id
JOIN documents d1 ON e1.document_id = d1.id
JOIN documents d2 ON e2.document_id = d2.id
WHERE d1.id = $1  -- Input document ID
ORDER BY similarity DESC
LIMIT 10;
```

#### 3. Hybrid Search (Vector + Keyword)
```sql
-- Combine vector similarity with text search
SELECT 
  d.id,
  d.content,
  (1 - (e.embedding <=> $1::VECTOR)) as vector_score,
  ts_rank(to_tsvector('english', d.content), 
          plainto_tsquery('english', $2)) as keyword_score,
  (0.7 * (1 - (e.embedding <=> $1::VECTOR)) + 
   0.3 * ts_rank(to_tsvector('english', d.content), 
                 plainto_tsquery('english', $2))) as combined_score
FROM embeddings e
JOIN documents d ON e.document_id = d.id
ORDER BY combined_score DESC
LIMIT 20;
```

### 🧠 Embedding Generation Workflows

#### Using OpenAI API
```python
import openai
import psycopg2

# Initialize
openai.api_key = os.environ.get("OPENAI_API_KEY")
conn = psycopg2.connect("dbname=production_db user=engineer")

# Generate embeddings and store
def embed_document(document_text):
    response = openai.Embedding.create(
        model="text-embedding-3-small",
        input=document_text
    )
    return response['data'][0]['embedding']

# Insert into database
embedding = embed_document("Sample document content")
cur = conn.cursor()
cur.execute(
    "INSERT INTO embeddings (document_id, embedding, model_name) VALUES (%s, %s, %s)",
    (doc_id, embedding, "text-embedding-3-small")
)
conn.commit()
```

### 📊 Index Configuration

**HNSW Index Settings:**
```sql
CREATE INDEX ON embeddings USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);
```

**Explanation:**
- `m = 16`: Connections per node (balance: higher = slower build, faster search)
- `ef_construction = 64`: Search parameter during index building
- `vector_cosine_ops`: Use cosine distance (1 - dot product for normalized vectors)

### ⚡ Performance Tips

1. **Batch Inserts**: Insert embeddings in batches of 1000+
2. **Index After Load**: Build HNSW index after bulk loading embeddings
3. **Vacuum After Bulk Operations**: Run VACUUM ANALYZE
4. **Connection Pooling**: Use PgBouncer for high-concurrency embedding requests

```sql
-- Optimize after bulk load
VACUUM ANALYZE embeddings;
CREATE INDEX ON embeddings USING hnsw (embedding vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CLUSTER embeddings USING embeddings_embedding_idx;
```

### 🧪 Example Workflows

#### Document Ingestion Pipeline
1. Split documents into chunks (max 512 tokens)
2. Generate embedding for each chunk via OpenAI API
3. Batch insert (document, embedding, model_name, metadata)
4. Query with semantic search for RAG

#### Fine-tuning Search Quality
1. Collect user feedback (helpful/not helpful)
2. Store feedback in `search_results` table
3. Analyze failed queries to improve chunks or embeddings
4. Re-embed problematic documents with different chunking strategy

### 🔒 Security Considerations

1. **API Key Management**: Store OpenAI API key in .env, never commit
2. **Rate Limiting**: OpenAI has rate limits; implement backoff/retry logic
3. **Cost Optimization**: Use cheaper embedding models (text-embedding-3-small vs ada)
4. **Data Privacy**: Encrypt embeddings at rest if storing sensitive data

### 📈 Scaling Strategies

**Horizontal Scaling:**
- Distribute embeddings across multiple Citus worker nodes
- Shard embeddings by document_id for parallel search

**Vertical Scaling:**
- Increase PostgreSQL `work_mem` for larger HNSW construction
- Allocate more CPU for faster vector operations

### 📚 Resources

- **pgvector Docs**: https://github.com/pgvector/pgvector
- **OpenAI Embeddings**: https://platform.openai.com/docs/guides/embeddings
- **LangChain Integration**: https://python.langchain.com/docs/integrations/vectorstores/pgvector

### 🚀 Next Steps

1. Load `vector_search.sql` schema
2. Configure OpenAI API key in `.env`
3. Run embedding generation workflow
4. Test similarity search queries
5. Implement RAG application on top

---

**Last Updated:** May 2024
**Version:** 1.0
