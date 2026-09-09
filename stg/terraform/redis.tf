resource "google_redis_instance" "gitlab" {
  project            = var.service_project_id
  name               = "redis-gitlab-stg-01"
  region             = var.region
  tier               = "BASIC"
  memory_size_gb     = var.redis_memory_size_gb
  redis_version      = "REDIS_7_0"
  authorized_network = local.network_self_link
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  labels             = local.labels

  depends_on = [
    google_project_service.service_project,
    google_service_networking_connection.private_vpc_connection
  ]
}
