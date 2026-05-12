# Kubernetes & Cloud-Native PostgreSQL Requirements
## Yêu cầu Kỹ thuật Kubernetes & PostgreSQL Đám mây

### 🎯 Objective / Mục tiêu
- Deploy and manage a high-availability PostgreSQL cluster on Kubernetes.
- Triển khai và quản lý cụm PostgreSQL sẵn sàng cao trên K8s.

### 🛠️ Technical Stack / Công nghệ
- **CloudNativePG (CNPG)**: Kubernetes Operator for PostgreSQL.
- **Helm**: For package management.
- **StorageClass**: Standard or Premium SSD.

---

### 💻 Sample CNPG Cluster Manifest
File: `cluster-prod.yaml`

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: pg-prod-cluster
spec:
  instances: 3
  imageName: ghcr.io/cloudnativepg/postgresql:16
  
  storage:
    size: 50Gi
    storageClass: standard

  monitoring:
    enablePodMonitor: true

  backup:
    barmanObjectStore:
      destinationPath: s3://my-postgres-backups/
      s3Credentials:
        accessKeyId:
          name: aws-creds
          key: ACCESS_KEY_ID
        secretAccessKey:
          name: aws-creds
          key: SECRET_ACCESS_KEY
```
