# kubernetes/

This folder contains Kubernetes-based PostgreSQL infrastructure assets.

## What is included

- `cnpg-cluster.yaml` - CloudNativePG cluster manifest for a highly available PostgreSQL deployment.
- `REQUIREMENTS.md` - Required tools, Kubernetes prerequisites, and environment assumptions.

## Purpose

Use this folder to explore production-like PostgreSQL deployment on Kubernetes using CloudNativePG. It demonstrates operator-driven cluster creation, managed storage, backup configuration, and monitoring integration.

## Key concepts covered

- Kubernetes PostgreSQL operator deployment
- Managed PostgreSQL replicas and failover
- Persistent volume storage configuration
- WAL backup to object storage
- Operator-managed monitoring with PodMonitor

## Quick start

1. Prepare a Kubernetes cluster with RBAC and storage support.
2. Install the CloudNativePG operator.
3. Apply the manifest:

```powershell
kubectl apply -f e:\ABC\NoSQL\PostgreSQL\kubernetes\cnpg-cluster.yaml
```

4. Verify the cluster status:

```powershell
kubectl get postgresql -n database
kubectl get pods -n database
```

5. Confirm the `pg-production-ha` cluster becomes ready.

## Practical notes

- `cnpg-cluster.yaml` uses `ghcr.io/cloudnativepg/postgresql:16`.
- The example config sets `instances: 3` for an HA cluster.
- The operator bootstraps `commerce_db` with owner `engineer` using a Kubernetes secret named `pg-user-creds`.
- Backup is configured using `barmanObjectStore` to an S3-compatible bucket.

## Recommended extensions

For real clusters, add:

- `ServiceMonitor` or `PodMonitor` for Prometheus scraping.
- `pgBackRest` or `barman` for backup validation.
- `pgAudit` or `pg_stat_statements` for observability.

## Helm / Operator Checklist

Use Helm when you need repeatable operator installation and upgrades.

### Install CloudNativePG with Helm

```bash
helm repo add cloudnative-pg https://cloudnative-pg.github.io/charts
helm repo update
helm install cnpg cloudnative-pg/cloudnative-pg \
  --namespace database \
  --create-namespace
```

### Environment-specific values files

- `values-dev.yaml` - local development with 1 instance and no backups.
- `values-staging.yaml` - staging configuration with 2 instances and backup enabled.
- `values-prod.yaml` - production-grade configuration with 3 instances, backup, monitoring, and PDBs.

### Install using environment values

```bash
helm install cnpg-dev cloudnative-pg/cloudnative-pg --namespace database-dev --create-namespace -f values-dev.yaml
helm install cnpg-staging cloudnative-pg/cloudnative-pg --namespace database-staging --create-namespace -f values-staging.yaml
helm install cnpg-prod cloudnative-pg/cloudnative-pg --namespace database-prod --create-namespace -f values-prod.yaml
```

### Checklist for production operator deployments

- Confirm Kubernetes cluster capacity and storage class support.
- Validate RBAC and namespace isolation.
- Ensure persistent volumes are provisioned with `ReadWriteOnce` or the required policy.
- Configure secrets for database credentials (`pg-user-creds`) and backup credentials.
- Enable PodDisruptionBudgets and resource requests/limits.
- Add monitoring integration via `PodMonitor` or `ServiceMonitor`.
- Verify backup configuration, WAL archive destination, and retention policy.
- Test restore procedures before production rollout.
- Review operator logs and cluster events after manifest apply.


