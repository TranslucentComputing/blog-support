/**
 * Data resources for Sql Server deployment.
 *
 * Copyright 2024 Translucent Computing Inc.
 */
# Retrieve access token
data "google_service_account_access_token" "default" {
  target_service_account = var.impersonate_account
  scopes                 = ["cloud-platform"]
  lifetime               = "660s"
}

data "google_container_cluster" "cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.cluster_location
}

# Retrieve VPC from TF state
data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = var.data_vpc_bucket
    prefix = var.data_vpc_bucket_prefix
  }
}

# Retrieve GKE Management deployed after Vault from TF state
data "terraform_remote_state" "gke_man_after" {
  backend = "gcs"
  config = {
    bucket = var.data_gke_man_after_bucket
    prefix = var.data_gke_man_after_bucket_prefix
  }
}
