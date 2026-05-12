# vector-search/

This folder contains a PostgreSQL vector search example using the `pgvector` extension.

## What is included

- `vector_search.sql` - database schema, vector index, and similarity search function.

## Purpose

Use this folder to explore how PostgreSQL can be extended for AI retrieval workloads with vector embeddings, similarity search, and hybrid document retrieval.

## What this example covers

- Creating `pgvector` extension and vector-capable tables.
- Storing document metadata alongside vector embeddings.
- Building an HNSW index for fast nearest-neighbor search.
- Creating a reusable similarity search function.

## RAG Lab & Embedding Pipeline

This folder is now a lab for Retrieval-Augmented Generation (RAG):

- Ingest text documents and metadata.
- Store embeddings in PostgreSQL.
- Use similarity search to retrieve relevant context.
- Combine retrieved passages into a RAG prompt.

### Example RAG workflow

1. Generate embeddings using an embedding model.
2. Insert documents into `documents` and vectors into `embeddings`.
3. Query `match_documents(...)` to find similar content.
4. Concatenate top results for a downstream generative model.

## Quick start

1. Connect to PostgreSQL:

```powershell
psql -U engineer -d production_db
```

2. Run the example schema:

```powershell
psql -U engineer -d production_db -f e:\ABC\NoSQL\PostgreSQL\vector-search\vector_search.sql
```

3. Verify the objects:

```sql
SELECT * FROM pg_extension WHERE extname = 'vector';
SELECT tablename FROM pg_tables WHERE tablename IN ('documents','embeddings');
```

4. Insert a sample document and embedding:

```sql
INSERT INTO documents (content, metadata) VALUES ('Sample AI document about PostgreSQL.', '{"source":"example"}');
INSERT INTO embeddings (document_id, embedding, model_name)
VALUES (1, '[0.1,0.2,0.3,...]'::vector, 'openai-1536');
```

5. Run a similarity query:

```sql
SELECT * FROM match_documents('[0.1,0.2,0.3,...]'::vector, 0.7, 5);
```

## Embedding pipeline example

Use a Python script to generate vectors and insert them into PostgreSQL. Example:

```python
from openai import OpenAI
from psycopg import connect

client = OpenAI()
response = client.embeddings.create(
    input='Your query here',
    model='text-embedding-3-large'
)
vec = response.data[0].embedding

with connect('dbname=production_db user=engineer password=engineering_secret host=localhost') as conn:
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO documents (content, metadata) VALUES (%s, %s) RETURNING id",
            ('Example content about PostgreSQL internals', '{"source":"example"}')
        )
        document_id = cur.fetchone()[0]
        cur.execute(
            "INSERT INTO embeddings (document_id, embedding, model_name) VALUES (%s, %s, %s)",
            (document_id, vec, 'text-embedding-3-large')
        )
        conn.commit()
```

Then run the RAG retrieval query with a new query embedding and use the returned document content to build a prompt.

## Notes

- Adjust the embedding dimension if you use a different model.
- For production, store metadata in JSONB and version the model name.
- Use `match_documents(...)` as the retrieval component in a RAG pipeline.
