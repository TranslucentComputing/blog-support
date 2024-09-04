/**
 * Variables for Ollama deployment.
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

variable "data_op_bucket_oc" {
  description = "TF state GCS bucket for Oauth2 proxy Ollama"
  type        = string
}

variable "data_op_bucket_prefix_oc" {
  description = "Folder for the GCS bucket for Oauth2 proxy Ollama"
  type        = string
}

variable "chart_version" {
  description = "Helm chart version to deploy."
  type        = string
}

variable "chart_release_name" {
  type        = string
  description = "Helm chart release name"
}

variable "chart_name" {
  description = "Ollama Helm chart name in the repository."
  type        = string
}

variable "deployment_fullname" {
  type        = string
  description = "Helm chart fullname override."
}

variable "resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
      nvidia_gpu= optional(string)
    })
    limits = object({
      cpu    = string
      memory = string
      nvidia_gpu= string
    })
  })
  description = "Compute Resources required by the container. CPU/RAM/GPU requests/limits"
}

variable "storage_size" {
  description = "Size of the disk."
  type        = string
}

variable "models" {
  description = "List of models to pull from Ollama library."
  type        = list(string)
}

variable "ollama_domain" {
  type        = string
  description = "Ollama Ingress domain."
}

variable "additional_models" {
  description = "List of additional models to pull from Ollama library."
  type        = list(string)
  default     = []
}

variable "execute_download" {
  description = "Control whether to execute the model download."
  type        = bool
  default     = false
}

variable "enable_ingress" {
  description = "Flag to enable ingress."
  type        = bool
  default     = false
}
