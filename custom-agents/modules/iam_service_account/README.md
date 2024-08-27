# Google Service Account Module

This module allows simplified creation and management of one a service account and its IAM bindings.

Code from https://github.com/GoogleCloudPlatform/cloud-foundation-fabric was used to create this module.

## Example

```hcl
module "myproject-default-service-accounts" {
  source     = "../modules/iam-service-account"
  project_id = var.project_id
  name       = "vm-default"
  # authoritative roles granted *on* the service accounts to other identities
  iam = {
    "roles/iam.serviceAccountUser" = ["group:${var.group_email}"]
  }
  # non-authoritative roles granted *to* the service accounts on other resources
  iam_project_roles = {
    "${var.project_id}" = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
    ]
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | Optional description. | `string` | `null` | no |
| display\_name | Display name of the service account to create. | `string` | `"Terraform-managed."` | no |
| generate\_key | Generate a key for service account. | `bool` | `false` | no |
| iam | IAM bindings on the service account in {ROLE => [MEMBERS]} format. | `map(list(string))` | `{}` | no |
| iam\_billing\_roles | Billing account roles granted to this service account, by billing account id. Non-authoritative. | `map(list(string))` | `{}` | no |
| iam\_bindings | Authoritative IAM bindings in {KEY => {role = ROLE, members = [], condition = {}}}. Keys are arbitrary. | <pre>map(object({<br>    members = list(string)<br>    role    = string<br>    condition = optional(object({<br>      expression  = string<br>      title       = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| iam\_bindings\_additive | Individual additive IAM bindings on the service account. Keys are arbitrary. | <pre>map(object({<br>    member = string<br>    role   = string<br>    condition = optional(object({<br>      expression  = string<br>      title       = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| iam\_folder\_roles | Folder roles granted to this service account, by folder id. Non-authoritative. | `map(list(string))` | `{}` | no |
| iam\_organization\_roles | Organization roles granted to this service account, by organization id. Non-authoritative. | `map(list(string))` | `{}` | no |
| iam\_project\_roles | Project roles granted to this service account, by project id. | `map(list(string))` | `{}` | no |
| iam\_sa\_roles | Service account roles granted to this service account, by service account name. | `map(list(string))` | `{}` | no |
| iam\_storage\_roles | Storage roles granted to this service account, by bucket name. | `map(list(string))` | `{}` | no |
| name | Name of the service account to create. | `string` | n/a | yes |
| prefix | Prefix applied to service account names. | `string` | `null` | no |
| project\_id | Project id where service account will be created. | `string` | n/a | yes |
| public\_keys\_directory | Path to public keys data files to upload to the service account (should have `.pem` extension). | `string` | `""` | no |
| service\_account\_create | Create service account. When set to false, uses a data source to reference an existing service account. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| email | Service account email. |
| iam\_email | IAM-format service account email. |
| id | Fully qualified service account id. |
| key | Service account key. |
| name | Service account name. |
| service\_account | Service account resource. |
| service\_account\_credentials | Service account json credential templates for uploaded public keys data. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
