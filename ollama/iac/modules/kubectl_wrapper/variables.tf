/**
 * Variable for Kubectl module
 *
 * Copyright 2024 Translucent Computing Inc.
 */


variable "cluster_name" {
  description = "Name of the k8s cluster to connect to."
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Base64 encode PEM-encoded root certificates bundle for TLS authentication."
  type        = string
}

variable "kube_host" {
  description = "The hostname (in form of URI) of the Kubernetes API."
  type        = string
}

variable "command" {
  description = "kubectl command that will be executed."
  type        = string
}

variable "always_apply" {
  type = bool
  default = false
}
