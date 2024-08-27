# TERRAGRUNT CONFIGURATION
#
# Configuration for the prod environment.
#
# Copyright 2024 Translucent Computing Inc.


# Include configurations that are common used across multiple environments.
include "root" {
  path = find_in_parent_folders()
}

# Specify the source for the infrastructure deployment Terraform c
terraform {
  source = "${get_terragrunt_dir()}/../../../infra/deploy"
}

locals {
  # Automatically load environment-level variables from the parent folder
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Unpack variables for easy access within this configuration
  project_id       = local.environment_vars.locals.project_id
  region           = local.environment_vars.locals.region
  short_region     = local.environment_vars.locals.short_region
  zone1            = local.environment_vars.locals.zone1
  service_account  = local.environment_vars.locals.service_account

  # Determine the environment name based on the directory structure
  environment = element(split("/",path_relative_to_include()), 0)
}

# Inputs for the infrastructure deployment
inputs = {
  environment         = local.environment
  project_id          = local.project_id
  region              = local.region
  short_region        = local.short_region
  impersonate_account = local.service_account
  cluster_name        = "tc-tekstack-kps-${local.environment}-cluster"
  cluster_location    = local.zone1

  # Terraform state configuration for GKE management after Vault deployment
  data_gke_man_after_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_gke_man_after_bucket_prefix = "gke/management/${local.environment}/after_security"

  # VPC Terraform state configuration
  data_vpc_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_vpc_bucket_prefix = "vpc/${local.environment}"

  # Cloud SQL Configuration
  cloud_sql_instance_deletion_protection = false
  cloud_sql_instance_name_prefix = "northwind"
  cloud_sql_instance_machine_type = "db-custom-1-5120"
  cloud_sql_instance_engine = "SQLSERVER_2019_STANDARD"
  cloud_sql_instance_database_name = "northwind"
  cloud_sql_instance_backup_enabled = false
  cloud_sql_instance_backup_start_time = "04:00"
  cloud_sql_instance_maintenance_window_day = 7
  cloud_sql_instance_maintenance_window_hour = 1
  cloud_sql_instance_maintenance_track = "stable"
  cloud_sql_instance_disk_autoresize = true
  cloud_sql_instance_disk_size = 10
  cloud_sql_instance_disk_type = "PD_SSD"
  cloud_sql_instance_resource_timeout = "30m"

  # SQL Users Configuration
  cloud_sql_instance_sql_users = {
    username  = "kps-assistant-user"
    secret_name = "tc-tekstack-kps-prod-sql-server-assistant-user-sm"
    root_secret_name = "tc-tekstack-kps-prod-sql-server-root-user-sm"
  }

  # Additional configurations for Kubernetes and Kubert Assistant
  kube_database_secret = "mssql-northwind-secret"
  kubert_assistant_app_bucket = "kubert-assistant-mssql-agent-support"
}
