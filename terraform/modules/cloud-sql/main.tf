resource "google_sql_database_instance" "instance" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region
  
  settings {
    tier                        = var.tier
    availability_type           = var.enable_high_availability ? "REGIONAL" : "ZONAL"
    deletion_protection_enabled = var.environment == "production"
    
    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = var.backup_enabled
      transaction_log_retention_days = 7
    }
    
    ip_configuration {
      ipv4_enabled    = true
      private_network = var.private_network
      
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }
    
    database_flags {
      name  = "max_connections"
      value = "100"
    }
    
    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
    
    maintenance_window {
      day          = 7  # Domingo
      hour         = 3
      update_track = "stable"
    }
  }
  
  deletion_protection = var.environment == "production"
  
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "user" {
  name     = var.database_user
  instance = google_sql_database_instance.instance.name
  password = var.database_password
}

