# TERRAGRUNT CONFIGURATION
#
# Configuration for the prod environment.
#
# Copyright 2023 Translucent Computing Inc.


# Include configurations that are common used across multiple environments.
include "root" {
  path = find_in_parent_folders()
}

# Include the infra
terraform {
  source = "${get_terragrunt_dir()}/../../../infra/ollama"
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
  environment = element(split("/",path_relative_to_include()), 0)
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

  # TF state for external secrets management
  data_es_man_bucket = "tc-tekstack-kps-terraform-state-bucket"
  data_es_man_bucket_prefix = "gke/security/external_secrets/management/${local.environment}"

  # TF state for Keycloak management
  data_kc_man_bucket = "tc-tekstack-kps-terraform-state-bucket"
  data_kc_man_bucket_prefix = "gke/security/keycloak/management/${local.environment}/config"

  # Ingress TF state config
  data_ingress_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_ingress_bucket_prefix = "gke/ingress/nginx_ingress/${local.environment}"

  # Certs TF state config
  data_certs_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_certs_bucket_prefix = "gke/ingress/cert-manager/certs/${local.environment}"

  # TF state for Keycloak
  data_kc_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_kc_bucket_prefix = "gke/security/keycloak/${local.environment}"

  # Prom Stack state config
  data_prom_stack_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_prom_stack_bucket_prefix = "gke/observability/prometheus-stack/${local.environment}"

  # Ollam TF state config
  data_ollama_bucket        = "tc-tekstack-kps-terraform-state-bucket"
  data_ollama_bucket_prefix = "gke/assistant-support/ollama/${local.environment}"

  chart_version = "7.7.14"
  chart_release_name = "oauth2-proxy-ol"

  ollama_oauth_proxy_resources = {
    requests = {
      cpu    = "50m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
  cookie_name       = "_kubert_oauth"
  oauth2_url_prefix_ol = "oauth2"
  ollama_fullname_override = "oauth2-ollama"
}
