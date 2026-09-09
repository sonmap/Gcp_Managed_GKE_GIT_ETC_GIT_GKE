resource "google_compute_subnetwork" "gke" {
  project                  = var.host_project_id
  name                     = local.subnets.gke.name
  region                   = var.region
  network                  = local.network_self_link
  ip_cidr_range            = local.subnets.gke.ip_cidr_range
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod-gitlab"
    ip_cidr_range = local.subnets.gke.secondary_ranges.pod_gitlab
  }

  secondary_ip_range {
    range_name    = "svc-gitlab"
    ip_cidr_range = local.subnets.gke.secondary_ranges.svc_gitlab
  }
}

resource "google_compute_subnetwork" "cloudrun" {
  project                  = var.host_project_id
  name                     = local.subnets.cloudrun.name
  region                   = var.region
  network                  = local.network_self_link
  ip_cidr_range            = local.subnets.cloudrun.ip_cidr_range
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "cloudbuild" {
  project                  = var.host_project_id
  name                     = local.subnets.cloudbuild.name
  region                   = var.region
  network                  = local.network_self_link
  ip_cidr_range            = local.subnets.cloudbuild.ip_cidr_range
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "composer" {
  project                  = var.host_project_id
  name                     = local.subnets.composer.name
  region                   = var.region
  network                  = local.network_self_link
  ip_cidr_range            = local.subnets.composer.ip_cidr_range
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod-composer"
    ip_cidr_range = local.subnets.composer.secondary_ranges.pod_composer
  }

  secondary_ip_range {
    range_name    = "svc-composer"
    ip_cidr_range = local.subnets.composer.secondary_ranges.svc_composer
  }
}

resource "google_compute_global_address" "private_services" {
  provider      = google-beta
  project       = var.host_project_id
  name          = "psa-gitlab-stg"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = local.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = local.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services.name]
}
