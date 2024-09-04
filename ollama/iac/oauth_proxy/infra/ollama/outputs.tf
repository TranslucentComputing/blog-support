/*
 * Outputs for Oauth Proxy deployment.
 *
 * Copyright 2024 Translucent Computing Inc.
 */

output "oauth2_proxy_cookie_name_ol" {
  value       = var.cookie_name
  description = "Ollama OAuth2 Proxy cookie name"
}

output "oauth2_proxy_url_prefix_ol" {
  value       = var.oauth2_url_prefix_ol
  description = "Ollama OAuth2 Proxy URL prefix used to access proxy."
}
