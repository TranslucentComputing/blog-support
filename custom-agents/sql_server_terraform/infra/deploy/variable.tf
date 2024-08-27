/*
Description:    Variable definitions for the Cloud SQL deployment.
Author:         Patryk Golabek
Copyright:      2023 Translucent Computing Inc. All rights reserved.
*/

variable "impersonate_account" {
  type        = string
  description = "The service account that TF used for Google provider."
}

variable "environment" {
  description = "The deployment environment."
  type        = string
}

variable "project_id" {
  description = "Project ID."
  type        = string
}

variable "region" {
  description = "Project default region."
  type        = string
}

variable "cluster_name" {
  description = "Cluster name."
  type        = string
}

variable "cluster_location" {
  description = "Cluster zone or region."
  type        = string
}

variable "data_vpc_bucket" {
  description = "The GCS bucket where the VPC configuration is stored."
  type        = string
}

variable "data_vpc_bucket_prefix" {
  description = "The GCS bucket prefix where the VPC configuration is stored."
  type        = string
}

variable "data_gke_man_after_bucket" {
  description = "TF state GCS bucket for GKE management after Vault deployment."
  type        = string
}

variable "data_gke_man_after_bucket_prefix" {
  description = "Folder for the GCS bucket for GKE management after Vault deployment."
  type        = string
}

## Cloud SQL

# Whether or not to allow Terraform to destroy the instance.
variable "cloud_sql_instance_deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply command that deletes the instance will fail."
  type        = bool
  default     = "false"
}

variable "cloud_sql_instance_name_prefix" {
  type = string
  description = "Cloud SQL instance name prefix for the instance name.  Note, after a name is used, it cannot be reused for up to one week."
}

variable "cloud_sql_instance_engine" {
  type        = string
  description = "The MySQL, PostgreSQL or SQL Server version to use."
}

variable "cloud_sql_instance_machine_type" {
  description = "The machine type for the instances. See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing"
  type        = string
}

variable "cloud_sql_instance_backup_enabled" {
  description = "Set to false if you want to disable backup."
  type        = bool
}

variable "cloud_sql_instance_backup_start_time" {
  description = "HH:MM format (e.g. 04:00) time indicating when backup configuration starts. NOTE: Start time is randomly assigned if backup is enabled and 'backup_start_time' is not set"
  type        = string
}

variable "cloud_sql_instance_maintenance_window_day" {
  description = "Day of week (1-7), starting on Monday, on which system maintenance can occur. Performance may be degraded or there may even be a downtime during maintenance windows."
  type        = number
}

variable "cloud_sql_instance_maintenance_window_hour" {
  description = "Hour of day (0-23) on which system maintenance can occur. Ignored if 'maintenance_window_day' not set. Performance may be degraded or there may even be a downtime during maintenance windows."
  type        = number
}

variable "cloud_sql_instance_maintenance_track" {
  description = "Receive updates earlier (canary) or later (stable)."
  type        = string
}

variable "cloud_sql_instance_disk_autoresize" {
  description = "Second Generation only. Configuration to increase storage size automatically."
  type        = bool
}

variable "cloud_sql_instance_disk_size" {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  type        = number
}

variable "cloud_sql_instance_disk_type" {
  description = "The type of storage to use. Must be one of `PD_SSD` or `PD_HDD`."
  type        = string
}

# Resources are created sequentially. Therefore we increase the default timeouts considerably
# to not have the operations time out.
variable "cloud_sql_instance_resource_timeout" {
  description = "Timeout for creating, updating and deleting database instances. Valid units of time are s, m, h."
  type        = string
}

variable "cloud_sql_instance_database_name" {
  type        = string
  description = "The name of the database in the Cloud SQL instance."
}

variable "cloud_sql_instance_sql_users" {
  type = object({
    username    = string
    secret_name = string
    root_secret_name = string
  })
  description = "SQL database users."
}

variable "kube_database_secret" {
  description = "Name of the kubernetes secret where the database credentials are stored."
  type = string
}

variable "kubert_assistant_app_bucket" {
  description = "Google bucket used with Kubert assistant application."
  type = string
}
