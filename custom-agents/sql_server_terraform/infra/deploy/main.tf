/*
Description:    Main Terraform resources for the Cloud SQL deployment
Author:         Patryk Golabek
Copyright:      2024 Translucent Computing Inc. All rights reserved.
*/

# Fetches the secret version for the assistant user password from Google Secret Manager
data "google_secret_manager_secret_version" "assistant_password" {
  project =  var.project_id
  secret = var.cloud_sql_instance_sql_users.secret_name
}

# Fetches the secret version for the root user password from Google Secret Manager
data "google_secret_manager_secret_version" "root_password" {
  project =  var.project_id
  secret = var.cloud_sql_instance_sql_users.root_secret_name
}

# Generates a random ID used for naming the Cloud SQL instance
resource "random_id" "name" {
  byte_length = 4
}

# Defines the Cloud SQL database instance resource
resource "google_sql_database_instance" "northwind" {
  project          = var.project_id
  region           = var.region
  name             = "${var.cloud_sql_instance_name_prefix}-${random_id.name.hex}"
  database_version = var.cloud_sql_instance_engine
  root_password    = data.google_secret_manager_secret_version.root_password.secret_data

  settings {
    tier = var.cloud_sql_instance_machine_type
    disk_autoresize   = var.cloud_sql_instance_disk_autoresize
    disk_size         = var.cloud_sql_instance_disk_size
    disk_type         = var.cloud_sql_instance_disk_type

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.terraform_remote_state.vpc.outputs.vpc_id
    }

    backup_configuration {
      enabled                        = var.cloud_sql_instance_backup_enabled
      start_time                     = var.cloud_sql_instance_backup_start_time
    }

    maintenance_window {
      day          = var.cloud_sql_instance_maintenance_window_day
      hour         = var.cloud_sql_instance_maintenance_window_hour
      update_track = var.cloud_sql_instance_maintenance_track
    }
  }

  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = var.cloud_sql_instance_deletion_protection

  # Default timeouts are 10 minutes, which in most cases should be enough.
  # Sometimes the database creation can, however, take longer, so we
  # increase the timeouts slightly.
  timeouts {
    create = var.cloud_sql_instance_resource_timeout
    delete = var.cloud_sql_instance_resource_timeout
    update = var.cloud_sql_instance_resource_timeout
  }
}

# Defines the database within the Cloud SQL instance
resource "google_sql_database" "northwind" {
  name      = var.cloud_sql_instance_database_name
  instance  = google_sql_database_instance.northwind.name
  timeouts {
    create = var.cloud_sql_instance_resource_timeout
    delete = var.cloud_sql_instance_resource_timeout
    update = var.cloud_sql_instance_resource_timeout
  }
}

# Defines the SQL user for the Cloud SQL instance
resource "google_sql_user" "assistant_user" {
  instance        = google_sql_database_instance.northwind.name
  name            = var.cloud_sql_instance_sql_users.username
  password        = data.google_secret_manager_secret_version.assistant_password.secret_data
  type            = "BUILT_IN"

  timeouts {
    create = var.cloud_sql_instance_resource_timeout
    delete = var.cloud_sql_instance_resource_timeout
    update = var.cloud_sql_instance_resource_timeout
  }
}
