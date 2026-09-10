variable "host_project_id" {
  description = "Shared VPC host project ID."
  type        = string
  default     = "pjt-d-shared-base"
}

variable "service_project_id" {
  description = "Service project ID where GKE, Cloud SQL, Redis and GitLab are created."
  type        = string
  default     = "prj-b-cicd-local-236d"
}

variable "region" {
  description = "Google Cloud region."
  type        = string
  default     = "asia-northeast3"
}

variable "network_name" {
  description = "Existing Shared VPC name."
  type        = string
  default     = "vpc-d-shared-base"
}

variable "enable_project_services" {
  description = "Set true only when the Terraform runner has serviceusage.services.list and serviceusage.services.enable permissions."
  type        = bool
  default     = false
}

variable "create_network_subnets" {
  description = "Set false to use an existing Shared VPC subnet instead of creating new subnets."
  type        = bool
  default     = false
}

variable "existing_gke_subnet_name" {
  description = "Existing subnet name for the GKE Autopilot cluster."
  type        = string
  default     = "subnet-common-gke"
}

variable "gke_pod_range_name" {
  description = "Existing GKE pod secondary range name."
  type        = string
  default     = "pods-sbx-main"
}

variable "gke_service_range_name" {
  description = "Existing GKE service secondary range name. Leave empty when the subnet has no service secondary range."
  type        = string
  default     = ""
}

variable "create_private_service_connection" {
  description = "Set false when Private Service Access already exists on the VPC."
  type        = bool
  default     = false
}

variable "private_service_allocated_range_name" {
  description = "Existing or new allocated PSA range name."
  type        = string
  default     = "psa-vpc-d-shared-base"
}

variable "create_backup_bucket" {
  description = "Set false when the Terraform runner cannot create GCS buckets."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "GKE Autopilot cluster name."
  type        = string
  default     = "gke-gitlab-stg-01"
}

variable "gitlab_host_name" {
  description = "GitLab host name prefix."
  type        = string
  default     = "gitlab-stg"
}

variable "gitlab_base_domain" {
  description = "GitLab base domain. Create DNS A record after the external IP is assigned."
  type        = string
  default     = "sonmap.net"
}

variable "gitlab_namespace" {
  description = "Kubernetes namespace for GitLab."
  type        = string
  default     = "gitlab"
}

variable "gitlab_chart_version" {
  description = "GitLab Helm chart version."
  type        = string
  default     = "8.11.2"
}

variable "gitlab_initial_root_password" {
  description = "Initial GitLab root password."
  type        = string
  sensitive   = true
}

variable "db_tier" {
  description = "Cloud SQL PostgreSQL machine tier."
  type        = string
  default     = "db-custom-2-7680"
}

variable "redis_memory_size_gb" {
  description = "Memorystore Redis memory size in GB."
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "Enable deletion protection for stateful resources."
  type        = bool
  default     = false
}
