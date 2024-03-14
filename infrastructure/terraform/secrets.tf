# get this value by creating a oauth 2.0 client id on this page (AFTER SELECTING CORRECT PROJECT): https://console.cloud.google.com/apis/credentials?referrer=search&project=langfuse-test
resource "google_cloud_secret_manager_secret" "google_client" {
  project   = var.project_id
  secret_id = "GOOGLE_CLIENT_SECRET"
  replication {
    automatic = true
  }
}

resource "google_cloud_secret_manager_secret_iam_member" "google_client_cicd" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.google_client.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.wif_service_account}"
}

resource "google_cloud_secret_manager_secret_iam_member" "google_client_cloudrun" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.google_client.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.langfuse.email}"
}

resource "google_cloud_secret_manager_secret" "next_auth_secret" {
  project   = var.project_id
  secret_id = "NEXTAUTH_SECRET"
  replication {
    automatic = true
  }
}

resource "google_cloud_secret_manager_secret_iam_member" "next_auth_secret_cicd" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.next_auth_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.wif_service_account}"
}

resource "google_cloud_secret_manager_secret_iam_member" "next_auth_secret_cloudrun" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.next_auth_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.langfuse.email}"
}


resource "google_cloud_secret_manager_secret" "postgres_connection_url" {
  project   = var.project_id
  secret_id = "POSTGRES_CONNECTION_URL"
  replication {
    automatic = true
  }
}


resource "google_cloud_secret_manager_secret_iam_member" "postgres_connection_url_cicd" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.postgres_connection_url.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.wif_service_account}"
}

resource "google_cloud_secret_manager_secret_iam_member" "postgres_connection_url_cloudrun" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.postgres_connection_url.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.langfuse.email}"
}

resource "google_cloud_secret_manager_secret" "smtp_connection_url" {
  project   = var.project_id
  secret_id = "SMTP_CONNECTION_URL"
  replication {
    automatic = true
  }
}

resource "google_cloud_secret_manager_secret_iam_member" "smtp_connection_url_cicd" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.smtp_connection_url.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.wif_service_account}"
}

resource "google_cloud_secret_manager_secret_iam_member" "smtp_connection_url_cloudrun" {
  project   = var.project_id
  secret_id = google_cloud_secret_manager_secret.smtp_connection_url.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.langfuse.email}"
}
