variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "location" {
  type        = string
  description = "location for the resources to be created"
}

variable "environment" {
  type        = string
  description = "environment code"
}

variable "dns_managed_domain" {
  type        = string
  description = "managed dns domain for this project"
}

variable "wif_service_account" {
  type        = string
  description = "workload identity service account"
}

variable "project_groups" {
  description = "Project group members"
  type        = list(any)
}

# variable "firestore_location" {
#   description = "Location for the firestore"
#   type        = string
# }

# variable "cloud_function_users" {
#   type        = list(string)
#   description = "List of Cloud Function users who should have access to the function"
# }

# variable "google_oauth_client_id" {
#   type        = string
#   description = "Client ID to use Google OAuth for authenticating towards GCIP"
# }

# variable "google_oauth_client_secret" {
#   type        = string
#   description = "Client ID to use Google OAuth for authenticating towards GCIP"
# }

# variable "pinecone_env" {
#   type        = string
#   description = "Pinecone environment where our data is stored"
# }

# variable "pinecone_index_name" {
#   type        = string
#   description = "The name of the index in Pinecone where document vectors are stored"
# }
