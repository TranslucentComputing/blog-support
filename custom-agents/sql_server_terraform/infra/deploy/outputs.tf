/*
Description:    Outputs for the Cloud SQL deployment
Author:         Patryk Golabek
Copyright:      2024 Translucent Computing Inc. All rights reserved.
*/

output "instance_project" {
  description = "Cloud SQL database instance cloud project."
  value = var.project_id
}

output "instance_region" {
  description = "Cloud SQL database instance cloud region."
  value = var.region
}

output "instance_name" {
  description = "Cloud SQL database instance name."
  value       = google_sql_database_instance.northwind.name
}

output "database_name" {
  description = "Cloud SQL database name."
  value       = google_sql_database.northwind.name
}

output "sql_server_username" {
  description = "SQL Server user name"
  value       = var.cloud_sql_instance_sql_users.username
}

output "sql_server_password_secret_name" {
  description = "Security manager secret name for SQL Server user password"
  value = var.cloud_sql_instance_sql_users.secret_name
}

output "sql_server_root_password_secret_name" {
  description = "Security manager secret name for SQL Server root user password"
  value = var.cloud_sql_instance_sql_users.root_secret_name
}

output "sgl_server_kubernetes_secret_name" {
  value = kubernetes_secret.sa.metadata.0.name
  description = "Kubernetes secret name that is created with the database credentials."
}

output "kubert_assistant_mssql_agent_bucket_name" {
  description = "The name of the Google Cloud Storage bucket used by Kubert Assistant with MS SQL Server agnet."
  value       = google_storage_bucket.app_export_bucket.name
}
