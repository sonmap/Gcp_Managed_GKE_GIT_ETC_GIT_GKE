# stg GitLab on GKE Autopilot

## Resource Plan

| Area | Terraform resource | Name | CIDR / Spec | Purpose |
|---|---|---|---|---|
| Network | existing subnet by default | `subnet-common-gke` | check current CIDR | GKE Autopilot node subnet |
| Pod Range | existing secondary range | `pod-gitlab` | check current CIDR | GitLab Pod IP |
| Service Range | existing secondary range | `svc-gitlab` | check current CIDR | GKE Service IP |
| Cloud Run | optional subnet | `subnet-cloudrun-egress-stg` | `172.31.30.64/28` | Cloud Run VPC egress |
| Cloud Build | optional subnet | `subnet-cloudbuild-pool-stg` | `172.31.30.80/28` | Cloud Build private pool subnet |
| Composer | optional subnet | `subnet-composer-stg` | `172.31.30.96/27` | Composer subnet |
| GKE | `google_container_cluster.gitlab` | `gke-gitlab-stg-01` | Autopilot | GitLab runtime |
| Database | `google_sql_database_instance.gitlab` | `sql-gitlab-stg-01` | PostgreSQL 15 | External GitLab DB |
| Redis | `google_redis_instance.gitlab` | `redis-gitlab-stg-01` | Redis 7 / 1GB | External GitLab Redis |
| Backup | optional bucket | project based | disabled by default | GitLab backup target |
| GitLab | `helm_release.gitlab` | `gitlab` | GitLab CE chart | GitLab app |

## Existing Resource Mode

The default `terraform.tfvars.example` uses existing network resources to avoid CIDR and PSA conflicts.

| Variable | Default | Reason |
|---|---:|---|
| `create_network_subnets` | `false` | Use existing `subnet-common-gke` |
| `existing_gke_subnet_name` | `subnet-common-gke` | Avoid `172.31.30.0/27` conflict |
| `create_private_service_connection` | `false` | Use existing `psa-vpc-d-shared-base` |
| `create_backup_bucket` | `false` | Avoid GCS bucket create permission error |

Check existing GKE secondary range names before apply.

```bash
gcloud compute networks subnets describe subnet-common-gke \
  --project=pjt-d-shared-base \
  --region=asia-northeast3 \
  --format="yaml(name,ipCidrRange,secondaryIpRanges)"
```

Set these values in `terraform.tfvars` to the actual secondary range names from the command output.

```hcl
gke_pod_range_name     = "ACTUAL_POD_RANGE_NAME"
gke_service_range_name = "ACTUAL_SERVICE_RANGE_NAME"
```

## API Prerequisite

Run API enablement first with an account that has `serviceusage.services.enable`.

```bash
gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com \
  sqladmin.googleapis.com \
  redis.googleapis.com \
  servicenetworking.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  run.googleapis.com \
  dns.googleapis.com \
  --project=prj-b-cicd-local-236d
```

Keep `enable_project_services = false` when the Terraform runner does not have `serviceusage.services.list`.

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
