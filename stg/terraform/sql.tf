resource "random_password" "postgres" {
  length  = 24
  special = true
}

resource "google_sql_database_instance" "gitlab" {
  project          = var.service_project_id
  name             = "sql-gitlab-stg-01"
  region           = var.region
  database_version = "POSTGRES_15"

  settings {
    tier              = var.db_tier
    availability_type = "ZONAL"
    disk_type         = "PD_SSD"
    disk_size         = 100
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = local.network_self_link
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "18:00"
    }

    user_labels = local.labels
  }

  deletion_protection = var.deletion_protection

  depends_on = [
    google_project_service.service_project,
    google_service_networking_connection.private_vpc_connection
  ]
}

resource "google_sql_database" "gitlabhq_production" {
  project  = var.service_project_id
  name     = "gitlabhq_production"
  instance = google_sql_database_instance.gitlab.name
}

resource "google_sql_user" "gitlab" {
  project  = var.service_project_id
  name     = "gitlab"
  instance = google_sql_database_instance.gitlab.name
  password = random_password.postgres.result
}
