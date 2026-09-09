# stg GitLab on GKE Autopilot

## Resource Plan

| Area | Terraform resource | Name | CIDR / Spec | Purpose |
|---|---|---|---|---|
| Network | `google_compute_subnetwork.gke` | `subnet-gke-gitlab-stg` | `172.31.30.0/27` | GKE Autopilot node subnet |
| Pod Range | secondary range | `pod-gitlab` | `10.30.0.0/22` | GitLab Pod IP |
| Service Range | secondary range | `svc-gitlab` | `10.30.4.0/24` | GKE Service IP |
| Cloud Run | `google_compute_subnetwork.cloudrun` | `subnet-cloudrun-egress-stg` | `172.31.30.64/28` | Cloud Run VPC egress |
| Cloud Build | `google_compute_subnetwork.cloudbuild` | `subnet-cloudbuild-pool-stg` | `172.31.30.80/28` | Cloud Build private pool subnet |
| Composer | `google_compute_subnetwork.composer` | `subnet-composer-stg` | `172.31.30.96/27` | Composer subnet |
| GKE | `google_container_cluster.gitlab` | `gke-gitlab-stg-01` | Autopilot | GitLab runtime |
| Database | `google_sql_database_instance.gitlab` | `sql-gitlab-stg-01` | PostgreSQL 15 | External GitLab DB |
| Redis | `google_redis_instance.gitlab` | `redis-gitlab-stg-01` | Redis 7 / 1GB | External GitLab Redis |
| Backup | `google_storage_bucket.gitlab_backup` | project based | 30-day lifecycle | GitLab backup target |
| GitLab | `helm_release.gitlab` | `gitlab` | GitLab CE chart | GitLab app |

## Run

```bash
cd stg/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## After Apply

```bash
gcloud container clusters get-credentials gke-gitlab-stg-01 \
  --project=prj-b-cicd-local-236d \
  --region=asia-northeast3

kubectl -n gitlab get ingress,svc,pod,pvc
```

Create an external DNS A record for `gitlab-stg.sonmap.net` after the external HTTPS IP is assigned.
