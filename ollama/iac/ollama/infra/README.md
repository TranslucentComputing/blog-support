<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_models | List of additional models to pull from Ollama library. | `list(string)` | `[]` | no |
| chart\_name | Ollama Helm chart name in the repository. | `string` | n/a | yes |
| chart\_release\_name | Helm chart release name | `string` | n/a | yes |
| chart\_version | Helm chart version to deploy. | `string` | n/a | yes |
| cluster\_location | Cluster zone or region. | `string` | n/a | yes |
| cluster\_name | Cluster name. | `string` | n/a | yes |
| data\_certs\_bucket | The GCS bucket where the Certs configuration is stored. | `string` | n/a | yes |
| data\_certs\_bucket\_prefix | The GCS bucket prefix where the Certs configuration is stored. | `string` | n/a | yes |
| data\_gke\_man\_after\_bucket | TF state GCS bucket for GKE management after Vault deployment. | `string` | n/a | yes |
| data\_gke\_man\_after\_bucket\_prefix | Folder for the GCS bucket for GKE management after Vault deployment. | `string` | n/a | yes |
| data\_gke\_man\_bucket | TF state GCS bucket for GKE management | `string` | n/a | yes |
| data\_gke\_man\_bucket\_prefix | Folder for the GCS bucket for GKE management | `string` | n/a | yes |
| data\_ingress\_bucket | The GCS bucket where the Ingress configuration is stored. | `string` | n/a | yes |
| data\_ingress\_bucket\_prefix | The GCS bucket prefix where the Ingress configuration is stored. | `string` | n/a | yes |
| data\_op\_bucket\_oc | TF state GCS bucket for Oauth2 proxy Ollama | `string` | n/a | yes |
| data\_op\_bucket\_prefix\_oc | Folder for the GCS bucket for Oauth2 proxy Ollama | `string` | n/a | yes |
| deployment\_fullname | Helm chart fullname override. | `string` | n/a | yes |
| enable\_ingress | Flag to enable ingress. | `bool` | `false` | no |
| environment | The deployment environment. | `string` | n/a | yes |
| execute\_download | Control whether to execute the model download. | `bool` | `false` | no |
| impersonate\_account | The service account that TF used for Google provider. | `string` | n/a | yes |
| models | List of models to pull from Ollama library. | `list(string)` | n/a | yes |
| ollama\_domain | Ollama Ingress domain. | `string` | n/a | yes |
| project\_id | Project ID. | `string` | n/a | yes |
| resources | Compute Resources required by the container. CPU/RAM/GPU requests/limits | <pre>object({<br>    requests = object({<br>      cpu    = string<br>      memory = string<br>      nvidia_gpu= optional(string)<br>    })<br>    limits = object({<br>      cpu    = string<br>      memory = string<br>      nvidia_gpu= string<br>    })<br>  })</pre> | n/a | yes |
| storage\_size | Size of the disk. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ollama\_ingress\_hostname | Ollama ingress hostname |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->