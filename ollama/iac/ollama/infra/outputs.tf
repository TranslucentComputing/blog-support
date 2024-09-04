/*
 * Outputs for Ollama deployment.
 *
 * Copyright 2024 Translucent Computing Inc.
 */

output "ollama_ingress_hostname" {
  value       = var.ollama_domain
  description = "Ollama ingress hostname"
}
