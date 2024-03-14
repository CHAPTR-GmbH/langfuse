# TODO: this should be private IP instead!
resource "google_sql_database_instance" "langfuse" {
  database_version = "POSTGRES_15"
  name             = "langfuse-db"
  project          = var.project_id
  region           = "europe-west9"

  settings {
    activation_policy           = "ALWAYS"
    availability_type           = "ZONAL"
    connector_enforcement       = "NOT_REQUIRED"
    deletion_protection_enabled = true
    disk_autoresize             = true
    disk_autoresize_limit       = 0
    disk_size                   = 10
    disk_type                   = "PD_SSD"
    edition                     = "ENTERPRISE"
    pricing_plan                = "PER_USE"
    tier                        = "db-custom-2-8192"
    user_labels                 = {}
    version                     = 22

    backup_configuration {
      binary_log_enabled             = false
      enabled                        = true
      location                       = "eu"
      point_in_time_recovery_enabled = true
      start_time                     = "18:00"
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    insights_config {
      query_insights_enabled  = false
      query_plans_per_minute  = 0
      query_string_length     = 0
      record_application_tags = false
      record_client_address   = false
    }

    ip_configuration {
      enable_private_path_for_google_cloud_services = false
      ipv4_enabled                                  = true
      require_ssl                                   = false
    }

    location_preference {
      zone = "europe-west9-c"
    }

    maintenance_window {
      day  = 0
      hour = 0
    }
  }
}
