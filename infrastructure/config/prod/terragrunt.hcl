locals {
  location                   = "europe-west4"
  project_id                 = "langfuse-test" # adapt project NUMBER !!!
  tf_service_account         = "tf-admin@langfuse-test.iam.gserviceaccount.com"
  wif_service_account        = "wi-langfuse-prod@workload-identity-github-849b.iam.gserviceaccount.com"
  environment                = "prod"
  dns_managed_domain         = "prod.langfuse.gcp.chaptr.xyz"
  project_groups             = ["group:engineering@chaptr.ai"]
  # firestore_location         = "eur3"
  # cloud_function_users       = []
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  location                   = local.location
  project_id                 = local.project_id
  environment                = local.environment
  dns_managed_domain         = local.dns_managed_domain
  wif_service_account        = local.wif_service_account
  project_groups             = local.project_groups
  # firestore_location         = local.firestore_location
  # cloud_function_users       = local.cloud_function_users
  # google_oauth_client_id     = local.google_oauth_client_id
  # google_oauth_client_secret = local.google_oauth_client_secret
  # pinecone_env               = local.pinecone_env
  # pinecone_index_name        = local.pinecone_index_name
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email"
  ]
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonation
  target_service_account = "${local.tf_service_account}"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "2400s"
}

provider "google" {
  project         = "${local.project_id}"
  region          = "${local.location}"
  zone            = "${local.location}-c"
  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}

provider "google-beta" {
  project         = "${local.project_id}"
  region          = "${local.location}"
  zone            = "${local.location}-c"
  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}
    EOF
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "remotestate.tf"
    if_exists = "overwrite"
  }
  config = {
    project              = local.project_id
    bucket               = "${local.project_id}-europe-west2-state-bucket"
    prefix               = "tfstate"
    location             = local.location
    skip_bucket_creation = true
  }
}

terraform {
  source = "../..//terraform"
}
