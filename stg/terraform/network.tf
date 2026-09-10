resource "google_compute_subnetwork" "gke" {
  count = var.create_network_subnets ? 1 : 0

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
  count = var.create_network_subnets ? 1 : 0

  project                  = var.host_project_id
  name                     = local.subnets.cloudrun.name
  region                   = var.region
  network                  = local.network_self_link
  ip_cidr_range            = local.subnets.cloudrun.ip_cidr_range
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "cloudbuild" {
  count = var.create_network_subnets ? 1 : 0

  project                  = var.host_project_id
  name                     = local.subnets.cloudbuild.name
  region                   = var.region
  network                  = local.network_self_link
  ip_cidr_range            = local.subnets.cloudbuild.ip_cidr_range
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "composer" {
  count = var.create_network_subnets ? 1 : 0

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

data "google_compute_subnetwork" "gke_existing" {
  count   = var.create_network_subnets ? 0 : 1
  project = var.host_project_id
  name    = var.existing_gke_subnet_name
  region  = var.region
}

resource "google_compute_global_address" "private_services" {
  count = var.create_private_service_connection ? 1 : 0

  provider      = google-beta
  project       = var.host_project_id
  name          = var.private_service_allocated_range_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = local.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count = var.create_private_service_connection ? 1 : 0

  provider                = google-beta
  network                 = local.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services[0].name]
}
