# TERRAGRUNT CONFIGURATION
#
# Configuration for the prod environment.
#
# Copyright 2024 Translucent Computing Inc.


# Include configurations that are common used across multiple environments.
include "root" {
  path = find_in_parent_folders()
}

# Include the infra
terraform {
  source = "${get_terragrunt_dir()}/../../infra"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Unpack variables for easy access
  project_id       = local.environment_vars.locals.project_id
  region           = local.environment_vars.locals.region
  short_region     = local.environment_vars.locals.short_region
  zone1            = local.environment_vars.locals.zone1
  service_account  = local.environment_vars.locals.service_account

  # This will get the directory name
  environment = basename(path_relative_to_include())
}

# Inputs for infra
inputs = {
  environment         = local.environment
  project_id          = local.project_id
  region              = local.region
  short_region        = local.short_region
  impersonate_account = local.service_account
  cluster_name        = "tc-tekstack-kps-${local.environment}-cluster"
  cluster_location    = local.zone1

  # TF state for GKE management
  data_gke_man_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_gke_man_bucket_prefix = "gke/management/${local.environment}/initial"

  # TF state for GKE management after Vault deployment
  data_gke_man_after_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_gke_man_after_bucket_prefix = "gke/management/${local.environment}/after_security"

  # Ingress TF state config
  data_ingress_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_ingress_bucket_prefix = "gke/ingress/nginx_ingress/${local.environment}"

  # Certs TF state config
  data_certs_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_certs_bucket_prefix = "gke/ingress/cert-manager/certs/${local.environment}"

  # TF state for Oauth Proxy
  data_op_bucket_oc = "tc-tekstack-kps-terraform-state-bucket"
  data_op_bucket_prefix_oc = "gke/security/oauth_proxy/${local.environment}/ollama"

  # Ollama chart config
  chart_name = "ollama"
  chart_release_name = "ollama"
  chart_version = "0.57.0"
  deployment_fullname = "ollama"

  # Ollama resources config
  resources = {
    requests = {
      cpu = "1"
      memory = "8Gi"
      nvidia_gpu = "1"
    }
    limits = {
      cpu = "2"
      memory = "10Gi"
      nvidia_gpu = "1"
    }
  }

  # Ollama ingress
  ollama_domain = "add me"
  enable_ingress = true # Default if false, enable it after oauth2-proxy is deployed.

  # Ollama storage size
  storage_size = "2Ti"

  # Ollama models
  models = [
    "llama3.1:8b", # 4.7GB
  ]

  # Pull additional Ollama models
  execute_download = false
  additional_models = [
    "llama3.1:405b", # 229GB
    "codegemma", # 5.0GB
    "gemma2:27b", # 16GB
    "phi3:14b", # 7.9GB
    "qwen2:7b", # 4.4GB
    "qwen2:72b", # 41GB
    "mistral-large", # 69GB
    "deepseek-coder-v2:236b", # 133GB
  ]
}
