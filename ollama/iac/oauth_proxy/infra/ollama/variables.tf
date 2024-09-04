/**
 * Variables for Oauth Proxy deployment.
 *
 * Copyright 2024 Translucent Computing Inc.
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

variable "cluster_name" {
  description = "Cluster name."
  type        = string
}

variable "cluster_location" {
  description = "Cluster zone or region."
  type        = string
}

# Data Sources

variable "data_gke_man_bucket" {
  description = "TF state GCS bucket for GKE management"
  type        = string
}

variable "data_gke_man_bucket_prefix" {
  description = "Folder for the GCS bucket for GKE management"
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

variable "data_es_man_bucket" {
  description = "TF state GCS bucket for external secrets management"
  type        = string
}

variable "data_es_man_bucket_prefix" {
  description = "Folder for the GCS bucket for external secrets management"
  type        = string
}

variable "data_ingress_bucket" {
  description = "The GCS bucket where the Ingress configuration is stored."
  type        = string
}

variable "data_ingress_bucket_prefix" {
  description = "The GCS bucket prefix where the Ingress configuration is stored."
  type        = string
}

variable "data_certs_bucket" {
  description = "The GCS bucket where the Certs configuration is stored."
  type        = string
}

variable "data_certs_bucket_prefix" {
  description = "The GCS bucket prefix where the Certs configuration is stored."
  type        = string
}

variable "data_kc_man_bucket" {
  description = "TF state GCS bucket for Keycloak management"
  type        = string
}

variable "data_kc_man_bucket_prefix" {
  description = "Folder for the GCS bucket for Keycloak management"
  type        = string
}

variable "data_kc_bucket" {
  description = "TF state GCS bucket for Keycloak"
  type        = string
}

variable "data_kc_bucket_prefix" {
  description = "Folder for the GCS bucket for Keycloak"
  type        = string
}

variable "data_prom_stack_bucket" {
  description = "TF state GCS bucket for Vault deployment."
  type        = string
}

variable "data_prom_stack_bucket_prefix" {
  description = "Folder for the GCS bucket for Vault deployment."
  type        = string
}

variable "data_ollama_bucket" {
  description = "TF state GCS bucket for Ollama deployment."
  type        = string
}

variable "data_ollama_bucket_prefix" {
  description = "Folder for the GCS bucket for Ollama deployment."
  type        = string
}

# Helm chart
variable "chart_version" {
  description = "Helm chart version to deploy."
  type        = string
}

variable "chart_release_name" {
  type        = string
  description = "Helm chart release name"
}

variable "cookie_name" {
  type        = string
  description = "Cookie name use by OAuth2 proxy."
}

variable "oauth2_url_prefix_ol" {
  type        = string
  description = "OAuth2 proxy URL path"
}

variable "ollama_fullname_override" {
  type        = string
  description = "Name used to override the helm chart name."
}

variable "ollama_oauth_proxy_resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  description = "Container resources."
}
