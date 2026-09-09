resource "google_project_service" "service_project" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
    "redis.googleapis.com",
    "servicenetworking.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "dns.googleapis.com"
  ])

  project            = var.service_project_id
  service            = each.value
  disable_on_destroy = false
}
