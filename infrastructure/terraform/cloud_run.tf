resource "google_service_account" "langfuse" {
  account_id   = "langfuse-deployment"
  display_name = "langfuse-deployment"
  project      = var.project_id
}

resource "google_cloud_run_service" "langfuse" {
  autogenerate_revision_name = true
  location                   = var.location
  name                       = "langfuse"
  project                    = var.project_id

  template {
    spec {
      container_concurrency = 80
      service_account_name  = google_service_account.langfuse.email
      timeout_seconds       = 300

      containers {
        args    = []
        command = []
        # TODO: reference artifact_registry here
        image = "${google_artifact_registry_repository.langfuse.location}-docker.pkg.dev/${google_artifact_registry_repository.langfuse.location}/${google_artifact_registry_repository.langfuse.name}/langfuse:latest"
        name  = "langfuse-1"

        env {
          name  = "AUTH_DISABLE_USERNAME_PASSWORD"
          value = "true"
        }
        env {
          name  = "AUTH_GOOGLE_ALLOWED_DOMAINS"
          value = "chaptr.xyz,chaptr.ai"
        }
        env {
          name = "AUTH_GOOGLE_CLIENT_ID"
          # needs to come from oauth app credentials
          value = ""
        }
        env {
          name = "AUTH_GOOGLE_CLIENT_SECRET"

          value_from {
            secret_key_ref {
              key = "latest"
              # reference secret here
              name = "GOOGLE_CLIENT_SECRET"
            }
          }
        }
        env {
          name  = "EMAIL_FROM_ADDRESS"
          value = "langfuse@chaptr.ai"
        }
        env {
          name = "DATABASE_URL"

          value_from {
            secret_key_ref {
              key = "latest"
              # reference secret here
              name = "POSTGRES_CONNECTION_URL"
            }
          }
        }
        env {
          name = "NEXTAUTH_SECRET"

          value_from {
            secret_key_ref {
              key = "latest"
              # reference secret here
              name = "NEXTAUTH_SECRET"
            }
          }
        }
        env {
          name = "NEXTAUTH_URL"
          # replace with service url
          # value = "https://langfuse-7bba3zvc2a-ew.a.run.app"
          value = ""
        }
        env {
          name  = "NEXT_PUBLIC_SIGN_UP_DISABLED"
          value = "false"
        }
        env {
          name = "SALT"
          # replace salt value
          #value = "gimmesomesaltbaby"
          value = ""
        }
        env {
          name = "SMTP_CONNECTION_URL"

          value_from {
            secret_key_ref {
              key = "latest"
              # replace with reference to secret
              name = "SMTP_CONNECTION_URL"
            }
          }
        }

        ports {
          container_port = 3000
          name           = "http1"
        }

        resources {
          limits = {
            "cpu"    = "1000m"
            "memory" = "512Mi"
          }
          requests = {}
        }

        startup_probe {
          failure_threshold     = 1
          initial_delay_seconds = 0
          period_seconds        = 240
          timeout_seconds       = 240

          tcp_socket {
            port = 3000
          }
        }
      }
    }
  }

  traffic {
    latest_revision = true
    percent         = 100
  }
}

resource "google_cloud_run_service_iam_member" "langfuse_users" {
  location = var.location
  project  = var.project_id
  service  = google_cloud_run_service.langfuse.name

  role       = "roles/run.invoker"
  member     = "allUsers"
  depends_on = [google_cloud_run_service.langfuse]
}


resource "google_cloud_run_service_iam_member" "langfuse_cicd" {
  location = var.location
  project  = var.project_id
  service  = google_cloud_run_service.langfuse.name

  role       = "roles/run.developer"
  member     = "serviceAccount:${var.wif_service_account}"
  depends_on = [google_cloud_run_service.langfuse]
}

