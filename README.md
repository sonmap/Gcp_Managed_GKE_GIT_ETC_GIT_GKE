# GKE GitLab Terraform

This repository contains a staging Terraform baseline for GitLab on GKE Autopilot.

## Layout

```text
stg/terraform
```

The staging stack creates:

- Shared VPC subnets for GKE, Cloud Run egress, Cloud Build private pool, and Composer
- GKE Autopilot cluster
- Cloud SQL for PostgreSQL
- Memorystore for Redis
- GCS bucket for GitLab backups
- GitLab Helm release
