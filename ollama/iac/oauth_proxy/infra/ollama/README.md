<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chart\_release\_name | Helm chart release name | `string` | n/a | yes |
| chart\_version | Helm chart version to deploy. | `string` | n/a | yes |
| cluster\_location | Cluster zone or region. | `string` | n/a | yes |
| cluster\_name | Cluster name. | `string` | n/a | yes |
| cookie\_name | Cookie name use by OAuth2 proxy. | `string` | n/a | yes |
| data\_certs\_bucket | The GCS bucket where the Certs configuration is stored. | `string` | n/a | yes |
| data\_certs\_bucket\_prefix | The GCS bucket prefix where the Certs configuration is stored. | `string` | n/a | yes |
| data\_es\_man\_bucket | TF state GCS bucket for external secrets management | `string` | n/a | yes |
| data\_es\_man\_bucket\_prefix | Folder for the GCS bucket for external secrets management | `string` | n/a | yes |
| data\_gke\_man\_after\_bucket | TF state GCS bucket for GKE management after Vault deployment. | `string` | n/a | yes |
| data\_gke\_man\_after\_bucket\_prefix | Folder for the GCS bucket for GKE management after Vault deployment. | `string` | n/a | yes |
| data\_gke\_man\_bucket | TF state GCS bucket for GKE management | `string` | n/a | yes |
| data\_gke\_man\_bucket\_prefix | Folder for the GCS bucket for GKE management | `string` | n/a | yes |
| data\_ingress\_bucket | The GCS bucket where the Ingress configuration is stored. | `string` | n/a | yes |
| data\_ingress\_bucket\_prefix | The GCS bucket prefix where the Ingress configuration is stored. | `string` | n/a | yes |
| data\_kc\_bucket | TF state GCS bucket for Keycloak | `string` | n/a | yes |
| data\_kc\_bucket\_prefix | Folder for the GCS bucket for Keycloak | `string` | n/a | yes |
| data\_kc\_man\_bucket | TF state GCS bucket for Keycloak management | `string` | n/a | yes |
| data\_kc\_man\_bucket\_prefix | Folder for the GCS bucket for Keycloak management | `string` | n/a | yes |
| data\_ollama\_bucket | TF state GCS bucket for Ollama deployment. | `string` | n/a | yes |
| data\_ollama\_bucket\_prefix | Folder for the GCS bucket for Ollama deployment. | `string` | n/a | yes |
| data\_prom\_stack\_bucket | TF state GCS bucket for Vault deployment. | `string` | n/a | yes |
| data\_prom\_stack\_bucket\_prefix | Folder for the GCS bucket for Vault deployment. | `string` | n/a | yes |
| environment | The deployment environment. | `string` | n/a | yes |
| impersonate\_account | The service account that TF used for Google provider. | `string` | n/a | yes |
| oauth2\_url\_prefix\_ol | OAuth2 proxy URL path | `string` | n/a | yes |
| ollama\_fullname\_override | Name used to override the helm chart name. | `string` | n/a | yes |
| ollama\_oauth\_proxy\_resources | Container resources. | <pre>object({<br>    requests = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    limits = object({<br>      cpu    = string<br>      memory = string<br>    })<br>  })</pre> | n/a | yes |
| project\_id | Project ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| oauth2\_proxy\_cookie\_name\_ol | Ollama OAuth2 Proxy cookie name |
| oauth2\_proxy\_url\_prefix\_ol | Ollama OAuth2 Proxy URL prefix used to access proxy. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->