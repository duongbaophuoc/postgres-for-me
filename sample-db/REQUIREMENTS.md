# Sample Database: E-Commerce Schema
## Cơ sở dữ liệu Mẫu: Lược đồ Thương mại Điện tử

### 🎯 Objective / Mục tiêu
- Provide a realistic, production-grade e-commerce OLTP schema.
- Cung cấp lược đồ OLTP thương mại điện tử thực tế, cấp production.
- Demonstrate PostgreSQL features: constraints, partitioning, UUIDs, FKs.

### 📋 Schema Overview

**Tables:**
1. `users` - Customer accounts
2. `products` - Product catalog
3. `orders` - Order master (partitioned by date)
4. `order_items` - Order line items
5. `reviews` - Product reviews with ratings
6. `inventory_logs` - Audit trail for inventory changes

**Relationships:**
```
users ─────┐
           ├─→ orders ─────→ order_items ─────→ products
           └─→ reviews ────→ products
           
inventory_logs ──→ products
```

### 🚀 Usage

#### Load Schema
```bash
psql -h localhost -U engineer -d production_db -f sample-db/commerce_db.sql
```

#### Verify Tables
```bash
psql -h localhost -U engineer -d production_db -c "\dt"
```

Expected output:
```
           List of relations
 Schema |    Name    | Type  | Owner
--------+------------+-------+--------
 public | inventory_logs | table | engineer
 public | order_items    | table | engineer
 public | orders         | table | engineer
 public | products       | table | engineer
 public | reviews        | table | engineer
 public | users          | table | engineer
```

### 📊 Data Characteristics

**Scale Factors (Production Sizing):**
- Users: ~100K accounts
- Products: ~10K SKUs
- Orders: ~1M transactions (2024)
- Order Items: ~3M line items
- Reviews: ~500K user reviews

**Estimated Storage:**
- Base tables: ~2-3 GB
- Indexes: ~800 MB
- With historical data: ~50+ GB

### 🔑 Key Features Demonstrated

1. **UUID v4 Primary Keys**: All entities use UUID instead of integer sequences
2. **NOT NULL Constraints**: Required fields at schema level
3. **CHECK Constraints**: Price >= 0, stock >= 0
4. **Foreign Keys**: Referential integrity enforcement
5. **UNIQUE Constraints**: Email uniqueness, product SKU uniqueness
6. **Range Partitioning**: Orders table partitioned by `created_at`
7. **TIMESTAMPTZ**: All timestamps in UTC timezone
8. **JSONB Columns**: Flexible metadata storage

### 📈 Sample Queries

#### Top Customers by Revenue
```sql
SELECT u.email, COUNT(o.order_id) as order_count, SUM(o.total_amount) as revenue
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.email
ORDER BY revenue DESC
LIMIT 10;
```

#### Products by Review Score
```sql
SELECT p.name, AVG(r.rating) as avg_rating, COUNT(r.review_id) as review_count
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.name
HAVING COUNT(r.review_id) > 0
ORDER BY avg_rating DESC;
```

#### Monthly Order Trends
```sql
SELECT DATE_TRUNC('month', o.created_at) as month,
       COUNT(o.order_id) as order_count,
       SUM(o.total_amount) as total_revenue
FROM orders o
GROUP BY DATE_TRUNC('month', o.created_at)
ORDER BY month DESC;
```

### 🧪 Testing

#### Insert Test Data
```bash
# Generate sample data
psql -h localhost -U engineer -d production_db <<EOF
INSERT INTO users (email, full_name) VALUES
  ('alice@example.com', 'Alice Smith'),
  ('bob@example.com', 'Bob Johnson'),
  ('charlie@example.com', 'Charlie Brown');

INSERT INTO products (sku, name, price) VALUES
  ('SKU-001', 'Laptop Pro', 1299.99),
  ('SKU-002', 'USB Cable', 9.99),
  ('SKU-003', 'Mouse Wireless', 29.99);
EOF
```

#### Verify Data
```sql
SELECT COUNT(*) as user_count FROM users;
SELECT COUNT(*) as product_count FROM products;
SELECT COUNT(*) as order_count FROM orders;
```

### 🔒 Security Considerations

1. **No plain passwords stored** - column: `password_hash` (use bcrypt in application)
2. **Row-Level Security**: Can be added for multi-tenant scenarios
3. **Audit Logging**: `inventory_logs` tracks all product stock changes
4. **GDPR Compliance**: Include `created_at` for data retention policies

### 🚀 Extension Points

**Possible Enhancements:**
1. Add `wishlist` table for saved products
2. Add `carts` table for abandoned cart analysis
3. Add `notifications` table for order status updates
4. Add `payment_methods` table for secure payment handling
5. Implement Row-Level Security for multi-tenant support

### 📚 Related Documentation
- [Data Modeling Guide](../docs/0-data-modeling/README.md)
- [Query Optimization](../docs/1-fundamentals/README.md)
- [Production Operations](../docs/4-operations/README.md)
