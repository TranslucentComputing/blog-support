<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| always\_apply | n/a | `bool` | `false` | no |
| cluster\_ca\_certificate | Base64 encode PEM-encoded root certificates bundle for TLS authentication. | `string` | n/a | yes |
| cluster\_name | Name of the k8s cluster to connect to. | `string` | n/a | yes |
| command | kubectl command that will be executed. | `string` | n/a | yes |
| kube\_host | The hostname (in form of URI) of the Kubernetes API. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
