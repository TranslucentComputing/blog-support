/**
 * Main resources for Ollama deployment.
 *
 * Copyright 2024 Translucent Computing Inc.
 */

locals {
  // Define the namespace from the remote state of GKE
  namespace = data.terraform_remote_state.gke_man_after.outputs.kubert_assistant_namespace

  // Define resource requests and limits for YAML configuration
  resources_for_yaml = {
    requests = {
      cpu         = var.resources.requests.cpu
      memory      = var.resources.requests.memory
      "nvidia.com/gpu" = lookup(var.resources.requests, "nvidia_gpu", null)
    }

    limits = {
      cpu         = var.resources.limits.cpu
      memory      = var.resources.limits.memory
      "nvidia.com/gpu" = lookup(var.resources.limits, "nvidia_gpu", null)
    }
  }

  oauth2_proxy_url_prefix_oc = try(data.terraform_remote_state.oauth_proxy[0].outputs.oauth2_proxy_url_prefix_ol,null)
  oauth2_proxy_cookie_name_ocs = try(data.terraform_remote_state.oauth_proxy[0].outputs.oauth2_proxy_cookie_name_ol,null)

  // Define ingress configuration for YAML
  ingress = <<EOF
ingress:
  enabled: ${var.enable_ingress}
  className: "${data.terraform_remote_state.ingress.outputs.ingress_class_name}"
  annotations:
    "nginx.ingress.kubernetes.io/proxy-buffer-size": "128k"
    "external-dns.alpha.kubernetes.io/hostname": "${var.ollama_domain}."
    "cert-manager.io/cluster-issuer": ${data.terraform_remote_state.certs.outputs.letsencrypt_cluster_issuer_prod}
    "nginx.ingress.kubernetes.io/limit-rps": "100"
    "nginx.ingress.kubernetes.io/enable-cors": "true"
    "nginx.ingress.kubernetes.io/cors-allow-methods": "*"
    "nginx.ingress.kubernetes.io/cors-allow-origin": "https://${var.ollama_domain}"
    "nginx.ingress.kubernetes.io/cors-allow-credentials": "true"
    "nginx.ingress.kubernetes.io/auth-response-headers": Authorization
    "nginx.ingress.kubernetes.io/auth-url": "https://$host/${(local.oauth2_proxy_url_prefix_oc != null ? local.oauth2_proxy_url_prefix_oc : "")}/auth"
    "nginx.ingress.kubernetes.io/auth-signin": "https://$host/${(local.oauth2_proxy_url_prefix_oc != null ? local.oauth2_proxy_url_prefix_oc : "")}/start?rd=$escaped_request_uri"
    "nginx.ingress.kubernetes.io/configuration-snippet": |
        auth_request_set $oauth_upstream_1 $upstream_cookie_${(local.oauth2_proxy_cookie_name_ocs != null ? local.oauth2_proxy_cookie_name_ocs : "")}_1;
        access_by_lua_block {
              if ngx.var.oauth_upstream_1 ~= "" then
                ngx.header["Set-Cookie"] = "${(local.oauth2_proxy_cookie_name_ocs != null ? local.oauth2_proxy_cookie_name_ocs : "")}_1=" .. ngx.var.oauth_upstream_1 .. ngx.var.auth_cookie:match("(; .*)")
              end
            }
        more_clear_headers "Server";
        more_clear_headers "X-Powered-By";
        more_set_headers "X-Frame-Options SAMEORIGIN";
        more_set_headers "X-Xss-Protection: 1; mode=block";
        more_set_headers "X-Content-Type-Options: nosniff";
        more_set_headers "X-Permitted-Cross-Domain-Policies: none";
        more_set_headers "Referrer-Policy: no-referrer";
        more_set_headers "Content-Security-Policy: img-src 'self' data:; font-src 'self' data:; script-src 'unsafe-inline' 'self'; style-src 'unsafe-inline' 'self'; default-src https://${var.ollama_domain}";
        more_set_headers "Permissions-Policy: accelerometer=(),autoplay=(),camera=(),display-capture=(),document-domain=(),encrypted-media=(),fullscreen=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),midi=(),payment=(),picture-in-picture=(),publickey-credentials-get=(),screen-wake-lock=(),sync-xhr=(self),usb=(),web-share=(self),xr-spatial-tracking=()";
  hosts:
    - host: ${var.ollama_domain}
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: ollama-kps-tls
      hosts:
        - ${var.ollama_domain}
EOF
}

# Deploy Ollama chart using Helm
resource "helm_release" "ollama" {
  repository       = "https://otwld.github.io/ollama-helm/"
  chart            = var.chart_name
  name             = var.chart_release_name
  version          = var.chart_version
  namespace        = local.namespace
  timeout          = 600 # 10 minutes, wait for post start hook to download models

  values = [
    "${file("values.yaml")}",
    yamlencode({resources=local.resources_for_yaml}),
    yamlencode({ollama={models=var.models}}),
    local.ingress
  ]

  set {
    name  = "fullnameOverride"
    value = var.deployment_fullname
  }

  // Set storage configuration
  set {
    name  = "persistentVolume.storageClass"
    value = data.terraform_remote_state.gke_man.outputs.storageclass_standard_retain_wait
  }
  set {
    name  = "persistentVolume.size"
    value = var.storage_size
  }
}

module "download_llms" {
  depends_on             = [ helm_release.ollama ]
  source                 = "../../../../../../modules/kubectl_wrapper"

  cluster_name           = data.google_container_cluster.cluster.name
  cluster_ca_certificate = data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  kube_host              = "https://${data.google_container_cluster.cluster.private_cluster_config[0].private_endpoint}"

  # Control variable to decide when to download models
  always_apply           = var.execute_download

  # Use the additional_models variable directly in the command
  command = <<EOT
  kubectl exec -n ${local.namespace} $(kubectl get pods -n ${local.namespace} -l app.kubernetes.io/name=${var.deployment_fullname} -o jsonpath="{.items[0].metadata.name}") -c ${var.chart_name} -- /bin/sh -c 'echo ${join(" ", var.additional_models)} | xargs -n1 /bin/ollama pull' > /tmp/ollama_pull.log 2>&1
  EOT
}
