/**
 * Main resources for Ollama Oauth Proxy deployment.
 *
 * Copyright 2024 Translucent Computing Inc.
 */

locals {
  # where to deploy the proxy
  namespace = data.terraform_remote_state.gke_man_after.outputs.kubert_assistant_namespace

  # KC client credentials for ollama
  ol_client_id = data.terraform_remote_state.kc_man.outputs.client_ollama_client_id
  ol_client_role = data.terraform_remote_state.kc_man.outputs.client_ollama_role_admin

  # Ollama URL
  ol_ingress_host = data.terraform_remote_state.ollama.outputs.ollama_ingress_hostname
  cors_allow_urls = "https://${local.ol_ingress_host}, https://${data.terraform_remote_state.kc.outputs.keycloak_domain}"
  oidc_url = "https://${data.terraform_remote_state.kc.outputs.keycloak_domain}/realms/${data.terraform_remote_state.kc_man.outputs.keycloak_ops_realm}"


  config = <<EOF
config:
  cookieName: ${var.cookie_name}
  existingSecret: ${data.terraform_remote_state.es_man.outputs.ollama_secret_name}
  configFile: |-
      email_domains = [ "${data.terraform_remote_state.kc_man.outputs.trusted_domain}" ]
      upstreams = [ "static://202" ]
EOF

  ingress = <<EOF
ingress:
  path: /${var.oauth2_url_prefix_ol}
  pathType: Prefix
  hosts:
    - ${local.ol_ingress_host}
  tls:
    - secretName: proxy-oc-tls
      hosts:
        - ${local.ol_ingress_host}
  className: "${data.terraform_remote_state.ingress.outputs.ingress_class_name}"
  annotations:
    external-dns.alpha.kubernetes.io/hostname: ${local.ol_ingress_host}.
    cert-manager.io/cluster-issuer: ${data.terraform_remote_state.certs.outputs.letsencrypt_cluster_issuer_prod}
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "1024m"
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-methods: "*"
    nginx.ingress.kubernetes.io/cors-allow-origin: "${local.cors_allow_urls}"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/limit-rps: "5"
    nginx.ingress.kubernetes.io/configuration-snippet: |
        more_clear_headers "Server";
        more_clear_headers "X-Powered-By";
        more_set_headers "X-Frame-Options SAMEORIGIN";
        more_set_headers "X-Xss-Protection: 1; mode=block";
        more_set_headers "X-Content-Type-Options: nosniff";
        more_set_headers "X-Permitted-Cross-Domain-Policies: none";
        more_set_headers "Referrer-Policy: no-referrer";
EOF

  ollama_oauth_proxy_resources = {
    resources = var.ollama_oauth_proxy_resources
  }

  extra_args = {
    extraArgs = {
      proxy-prefix = "${var.oauth2_url_prefix_ol}"
    }
  }
}

# Deploy oauth2-proxy Helm chart
resource "helm_release" "oauth_proxy_ol" {
  repository       = "https://oauth2-proxy.github.io/manifests"
  chart            = "oauth2-proxy"

  name             = var.chart_release_name
  version          = var.chart_version
  namespace        = local.namespace

  values = [
    "${file("values.yaml")}",
    yamlencode(local.ollama_oauth_proxy_resources),
    local.config,
    local.ingress
  ]

  # Set full name
  set {
    name  = "fullnameOverride"
    value = var.ollama_fullname_override
  }

  # Set Redirect url
  set {
    name  = "extraArgs.redirect-url"
    value = "https://${local.ol_ingress_host}/${var.oauth2_url_prefix_ol}/callback"
  }
  # Set oidc url
  set {
    name  = "extraArgs.oidc-issuer-url"
    value = local.oidc_url
  }
  # Allowed role
  set {
    name  = "extraArgs.allowed-role"
    value = "${local.ol_client_id}:${local.ol_client_role}"
  }

  set {
    name = "metrics.serviceMonitor.labels.${data.terraform_remote_state.prom_stack.outputs.prometheus_selector_key}"
    value = data.terraform_remote_state.prom_stack.outputs.prometheus_selector_value
  }
}
