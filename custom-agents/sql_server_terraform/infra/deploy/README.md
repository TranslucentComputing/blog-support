<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud\_sql\_instance\_backup\_enabled | Set to false if you want to disable backup. | `bool` | n/a | yes |
| cloud\_sql\_instance\_backup\_start\_time | HH:MM format (e.g. 04:00) time indicating when backup configuration starts. NOTE: Start time is randomly assigned if backup is enabled and 'backup\_start\_time' is not set | `string` | n/a | yes |
| cloud\_sql\_instance\_database\_name | The name of the database in the Cloud SQL instance. | `string` | n/a | yes |
| cloud\_sql\_instance\_deletion\_protection | Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply command that deletes the instance will fail. | `bool` | `"false"` | no |
| cloud\_sql\_instance\_disk\_autoresize | Second Generation only. Configuration to increase storage size automatically. | `bool` | n/a | yes |
| cloud\_sql\_instance\_disk\_size | Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. | `number` | n/a | yes |
| cloud\_sql\_instance\_disk\_type | The type of storage to use. Must be one of `PD_SSD` or `PD_HDD`. | `string` | n/a | yes |
| cloud\_sql\_instance\_engine | The MySQL, PostgreSQL or SQL Server version to use. | `string` | n/a | yes |
| cloud\_sql\_instance\_machine\_type | The machine type for the instances. See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing | `string` | n/a | yes |
| cloud\_sql\_instance\_maintenance\_track | Receive updates earlier (canary) or later (stable). | `string` | n/a | yes |
| cloud\_sql\_instance\_maintenance\_window\_day | Day of week (1-7), starting on Monday, on which system maintenance can occur. Performance may be degraded or there may even be a downtime during maintenance windows. | `number` | n/a | yes |
| cloud\_sql\_instance\_maintenance\_window\_hour | Hour of day (0-23) on which system maintenance can occur. Ignored if 'maintenance\_window\_day' not set. Performance may be degraded or there may even be a downtime during maintenance windows. | `number` | n/a | yes |
| cloud\_sql\_instance\_name\_prefix | Cloud SQL instance name prefix for the instance name.  Note, after a name is used, it cannot be reused for up to one week. | `string` | n/a | yes |
| cloud\_sql\_instance\_resource\_timeout | Timeout for creating, updating and deleting database instances. Valid units of time are s, m, h. | `string` | n/a | yes |
| cloud\_sql\_instance\_sql\_users | SQL database users. | <pre>object({<br>    username    = string<br>    secret_name = string<br>    root_secret_name = string<br>  })</pre> | n/a | yes |
| cluster\_location | Cluster zone or region. | `string` | n/a | yes |
| cluster\_name | Cluster name. | `string` | n/a | yes |
| data\_gke\_man\_after\_bucket | TF state GCS bucket for GKE management after Vault deployment. | `string` | n/a | yes |
| data\_gke\_man\_after\_bucket\_prefix | Folder for the GCS bucket for GKE management after Vault deployment. | `string` | n/a | yes |
| data\_vpc\_bucket | The GCS bucket where the VPC configuration is stored. | `string` | n/a | yes |
| data\_vpc\_bucket\_prefix | The GCS bucket prefix where the VPC configuration is stored. | `string` | n/a | yes |
| environment | The deployment environment. | `string` | n/a | yes |
| impersonate\_account | The service account that TF used for Google provider. | `string` | n/a | yes |
| kube\_database\_secret | Name of the kubernetes secret where the database credentials are stored. | `string` | n/a | yes |
| kubert\_assistant\_app\_bucket | Google bucket used with Kubert assistant application. | `string` | n/a | yes |
| project\_id | Project ID. | `string` | n/a | yes |
| region | Project default region. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| database\_name | Cloud SQL database name. |
| instance\_name | Cloud SQL database instance name. |
| instance\_project | Cloud SQL database instance cloud project. |
| instance\_region | Cloud SQL database instance cloud region. |
| kubert\_assistant\_mssql\_agent\_bucket\_name | The name of the Google Cloud Storage bucket used by Kubert Assistant with MS SQL Server agnet. |
| sgl\_server\_kubernetes\_secret\_name | Kubernetes secret name that is created with the database credentials. |
| sql\_server\_password\_secret\_name | Security manager secret name for SQL Server user password |
| sql\_server\_root\_password\_secret\_name | Security manager secret name for SQL Server root user password |
| sql\_server\_username | SQL Server user name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->