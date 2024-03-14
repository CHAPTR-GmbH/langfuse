generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "1.5.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.20.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.20.0"
    }
  }
}
    EOF
}

# Do not create any .tf resources in root if called there 
skip = true
