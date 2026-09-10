resource "kubernetes_secret" "gitlab_root" {
  metadata {
    name      = "gitlab-root-password"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
  }

  data = {
    password = var.gitlab_initial_root_password
  }
}

resource "kubernetes_secret" "postgres" {
  metadata {
    name      = "gitlab-postgres-password"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
  }

  data = {
    password = random_password.postgres.result
  }
}

resource "helm_release" "gitlab" {
  name       = "gitlab"
  namespace  = kubernetes_namespace.gitlab.metadata[0].name
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  version    = var.gitlab_chart_version
  timeout    = 1200

  values = [
    yamlencode({
      global = {
        edition = "ce"
        hosts = {
          domain = var.gitlab_base_domain
          https  = true
          gitlab = {
            name = var.gitlab_host_name
          }
        }
        ingress = {
          configureCertmanager = false
          class                 = "gce"
          provider              = "gce"
        }
        psql = {
          host     = google_sql_database_instance.gitlab.private_ip_address
          port     = 5432
          database = google_sql_database.gitlabhq_production.name
          username = google_sql_user.gitlab.name
          password = {
            secret = kubernetes_secret.postgres.metadata[0].name
            key    = "password"
          }
        }
        redis = {
          host = google_redis_instance.gitlab.host
          port = google_redis_instance.gitlab.port
        }
        initialRootPassword = {
          secret = kubernetes_secret.gitlab_root.metadata[0].name
          key    = "password"
        }
      }

      certmanager = {
        install = false
      }

      postgresql = {
        install = false
      }

      redis = {
        install = false
      }

      "nginx-ingress" = {
        enabled = false
      }

      gitlab = {
        webservice = {
          ingress = {
            annotations = {
              "kubernetes.io/ingress.class" = "gce"
            }
          }
        }
        gitaly = {
          persistence = {
            size = var.gitlab_gitaly_storage_size
          }
        }
      }

      "gitlab-runner" = {
        install = false
      }

      "gitlab-shell" = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "cloud.google.com/load-balancer-type" = "External"
          }
        }
      }

      registry = {
        enabled = false
      }

      prometheus = {
        install = false
      }
    })
  ]

  depends_on = [
    google_container_cluster.gitlab,
    google_sql_database.gitlabhq_production,
    google_redis_instance.gitlab,
    google_storage_bucket.gitlab_backup
  ]
}
