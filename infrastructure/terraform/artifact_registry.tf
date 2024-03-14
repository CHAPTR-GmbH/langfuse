resource "google_artifact_registry_repository" "langfuse" {
  location      = var.location
  project       = var.project_id
  repository_id = "langfuse"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "langfuse_cicd" {
  location   = var.location
  project    = var.project_id
  repository = google_artifact_registry_repository.langfuse.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${var.wif_service_account}"
}
