resource "google_storage_bucket" "gitlab_backup" {
  project                     = var.service_project_id
  name                        = "${var.service_project_id}-gitlab-stg-backup"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  labels = local.labels
}
