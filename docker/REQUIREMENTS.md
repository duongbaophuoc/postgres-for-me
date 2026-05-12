# Docker Production Environments Requirements
## Yêu cầu Kỹ thuật Môi trường Docker Sản xuất

### 🎯 Objective / Mục tiêu
- Run PostgreSQL with PgBouncer and Monitoring exporters in a single stack.
- Chạy PostgreSQL cùng PgBouncer và các bộ xuất chỉ số giám sát trong một stack duy nhất.

---

### 💻 Production-ready Docker Compose
File: `docker-compose.prod.yml`

```yaml
version: '3.8'

services:
  db:
    image: postgres:16-alpine
    container_name: pg_prod
    environment:
      POSTGRES_DB: production_db
      POSTGRES_PASSWORD: production_secret
    volumes:
      - pg_data:/var/lib/postgresql/data
    networks:
      - pg_network

  pgbouncer:
    image: edoburu/pgbouncer
    container_name: pgbouncer
    environment:
      - DATABASE_URL=postgres://postgres:production_secret@db:5432/production_db
      - MAX_CLIENT_CONN=1000
      - DEFAULT_POOL_SIZE=20
    ports:
      - "6432:6432"
    depends_on:
      - db
    networks:
      - pg_network

  postgres-exporter:
    image: prometheuscommunity/postgres-exporter
    environment:
      - DATA_SOURCE_NAME=postgresql://postgres:production_secret@db:5432/production_db?sslmode=disable
    ports:
      - "9187:9187"
    depends_on:
      - db
    networks:
      - pg_network

networks:
  pg_network:
    driver: bridge

volumes:
  pg_data:
```
