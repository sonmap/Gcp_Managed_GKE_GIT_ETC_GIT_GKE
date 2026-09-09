output "cluster_name" {
  value = google_container_cluster.gitlab.name
}

output "cluster_location" {
  value = google_container_cluster.gitlab.location
}

output "gke_subnet" {
  value = google_compute_subnetwork.gke.self_link
}

output "gitlab_domain" {
  value = "${var.gitlab_host_name}.${var.gitlab_base_domain}"
}

output "cloud_sql_private_ip" {
  value = google_sql_database_instance.gitlab.private_ip_address
}

output "redis_host" {
  value = google_redis_instance.gitlab.host
}

output "backup_bucket" {
  value = google_storage_bucket.gitlab_backup.name
}

output "get_credentials_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.gitlab.name} --project=${var.service_project_id} --region=${var.region}"
}

output "gitlab_lb_check_command" {
  value = "kubectl -n ${var.gitlab_namespace} get ingress,svc"
}
