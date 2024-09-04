/**
 * Main resources for Kubectl module
 *
 * Copyright 2024 Translucent Computing Inc.
 */

locals {

  temp_uuid = uuid()  # Generate the UUID once and store it in a local variable

  # Context name for the kube config
  context_name = "terraform-kps-${var.cluster_name}"

  # Kube config yaml for kubectl command
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = local.context_name
    clusters = [{
      name = var.cluster_name
      cluster = {
        certificate-authority-data = var.cluster_ca_certificate
        server                     = var.kube_host
      }
    }]
    contexts = [{
      name = local.context_name
      context = {
        cluster = var.cluster_name
        user    = local.context_name
      }
    }]
    users = [{
      name = local.context_name
      user = {
        exec = { # Command tailored for GKE
          apiVersion = "client.authentication.k8s.io/v1beta1"
          command = "gke-gcloud-auth-plugin"
        }
      }
    }]
  })
}

resource "null_resource" "kubectl" {

  triggers = {
    always_apply = var.always_apply ? timestamp() : 0
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = <<EOT
    TEMP_KUBECONFIG="/tmp/kubeconfig_${local.temp_uuid}.yaml"
    echo "$KUBECONFIG" | base64 -d > $TEMP_KUBECONFIG
    ${replace(var.command, "kubectl", "kubectl --kubeconfig /tmp/kubeconfig_${local.temp_uuid}.yaml")}
    rm $TEMP_KUBECONFIG
    EOT
    environment = {
      KUBECONFIG = base64encode(local.kubeconfig)
    }
  }
}
