locals {
  network_self_link = "projects/${var.host_project_id}/global/networks/${var.network_name}"

  subnets = {
    gke = {
      name          = "subnet-gke-gitlab-stg"
      ip_cidr_range = "172.31.30.0/27"
      secondary_ranges = {
        pod_gitlab = "10.30.0.0/22"
        svc_gitlab = "10.30.4.0/24"
      }
    }
    cloudrun = {
      name          = "subnet-cloudrun-egress-stg"
      ip_cidr_range = "172.31.30.64/28"
    }
    cloudbuild = {
      name          = "subnet-cloudbuild-pool-stg"
      ip_cidr_range = "172.31.30.80/28"
    }
    composer = {
      name          = "subnet-composer-stg"
      ip_cidr_range = "172.31.30.96/27"
      secondary_ranges = {
        pod_composer = "10.30.8.0/22"
        svc_composer = "10.30.12.0/24"
      }
    }
  }

  labels = {
    env     = "stg"
    service = "gitlab"
  }
}
