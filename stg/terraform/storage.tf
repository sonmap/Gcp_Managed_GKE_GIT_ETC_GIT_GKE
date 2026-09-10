resource "google_storage_bucket" "gitlab_backup" {
  count = var.create_backup_bucket ? 1 : 0

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
