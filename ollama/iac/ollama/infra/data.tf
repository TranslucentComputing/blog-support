/**
 * Data resources for Ollama deployment.
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

# Retrieve GKE Management from TF state
data "terraform_remote_state" "gke_man" {
  backend = "gcs"
  config = {
    bucket = var.data_gke_man_bucket
    prefix = var.data_gke_man_bucket_prefix
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

# Retrieve Ingress from TF state
data "terraform_remote_state" "ingress" {
  backend = "gcs"
  config = {
    bucket = var.data_ingress_bucket
    prefix = var.data_ingress_bucket_prefix
  }
}

# Retrieve Ingress from TF state
data "terraform_remote_state" "certs" {
  backend = "gcs"
  config = {
    bucket = var.data_certs_bucket
    prefix = var.data_certs_bucket_prefix
  }
}

data "terraform_remote_state" "oauth_proxy" {
  count = var.enable_ingress ? 1 : 0
  backend = "gcs"
  config = {
    bucket = var.data_op_bucket_oc
    prefix = var.data_op_bucket_prefix_oc
  }
}
