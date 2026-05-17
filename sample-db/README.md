# sample-db/ — Sample Databases
# sample-db/ — Cơ Sở Dữ Liệu Mẫu

This directory contains SQL schemas for the three sample databases used throughout the roadmap.

---

## Databases Overview / Tổng Quan Cơ Sở Dữ Liệu

| Database | Type | Tables | Use Case |
|----------|------|--------|----------|
| `commerce_db` | OLTP | 6 | E-commerce transactions |
| `analytics_dw` | OLAP | 4 | Data warehouse analytics |
| `vector_search_db` | AI/Vector | 3 | RAG & semantic search |

---

## Quick Start / Bắt Đầu Nhanh

### Prerequisites / Yêu cầu
- PostgreSQL 16+ running (local or Docker)
- `psql` CLI installed

### 1. Start PostgreSQL via Docker

```bash
docker compose -f ../docker/docker-compose.yml up -d
```

### 2. Create and Load commerce_db (OLTP)

```bash
# Create database
psql -U postgres -c "CREATE DATABASE commerce_db;"

# Load schema
psql -U postgres -d commerce_db -f commerce_db.sql

# Verify
psql -U postgres -d commerce_db -c "\dt"
```

Expected output:
```
           List of relations
 Schema |    Name     | Type  |  Owner
--------+-------------+-------+----------
 public | inventory   | table | postgres
 public | order_items | table | postgres
 public | orders      | table | postgres
 public | payments    | table | postgres
 public | products    | table | postgres
 public | users       | table | postgres
```

---

## Schema: commerce_db (OLTP)

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `users` | Customer accounts | id (UUID), email, created_at |
| `products` | Product catalog | id, name, price, category |
| `orders` | Order transactions | id, user_id, status, total |
| `order_items` | Line items per order | order_id, product_id, qty |
| `payments` | Payment records | order_id, method, status |
| `inventory` | Stock levels | product_id, quantity, warehouse |

---

## Files / Tập Tin

| File | Description |
|------|-------------|
| `commerce_db.sql` | OLTP schema — e-commerce (users, products, orders) |
| `REQUIREMENTS.md` | Full technical requirements for all 3 databases |

> **analytics_dw** and **vector_search_db** schemas are located in `../warehouses/` and `../vector-search/` respectively.

---

## Used In / Sử Dụng Ở

- **Stage 0** — Data Modeling exercises
- **Stage 1** — SQL fundamentals practice
- **Stage 2** — Backend integration examples
- **Stage 3** — EXPLAIN ANALYZE & indexing labs
- **Stage 4** — Backup & replication setup