# Projects & Engineering Case Studies
## Dự án & Nghiên cứu trường hợp Kỹ thuật

### 🎯 Objective / Mục tiêu
- Apply all stages of the roadmap to solve real-world infrastructure challenges.
- Áp dụng toàn bộ kiến thức lộ trình để giải quyết thách thức hạ tầng thực tế.

---

### 🚀 Project 1: Multi-Region Global E-commerce Data Platform
**Technical Requirements / Yêu cầu kỹ thuật:**
1. **Primary Region (US-East)**: 3-node HA cluster using Patroni + Citus for sharding.
2. **Secondary Region (EU-West)**: Read replicas with low-latency streaming.
3. **CDC Pipeline**: Debezium streaming orders to Kafka for real-time inventory updates.
4. **Analytics**: dbt models transforming OLTP data into a Star Schema warehouse for reporting.
5. **Observability**: Centralized Grafana dashboard monitoring CPU, TPS, and Replication Lag across regions.

### 📋 Deliverables / Sản phẩm bàn giao
- Infrastructure as Code (Terraform/Ansible).
- Kubernetes Manifests (Helm charts).
- Performance Benchmarking Report (pgbench).
- Incident Response Playbook (Disaster Recovery steps).
