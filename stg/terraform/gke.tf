resource "google_container_cluster" "gitlab" {
  provider = google-beta
  project  = var.service_project_id
  name     = var.cluster_name
  location = var.region

  enable_autopilot = true
  network          = local.network_self_link
  subnetwork       = google_compute_subnetwork.gke.self_link

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-gitlab"
    services_secondary_range_name = "svc-gitlab"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.130.3.0/28"
  }

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = var.deletion_protection

  depends_on = [
    google_project_service.service_project,
    google_compute_subnetwork.gke
  ]
}

resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.gitlab_namespace
  }

  depends_on = [google_container_cluster.gitlab]
}
