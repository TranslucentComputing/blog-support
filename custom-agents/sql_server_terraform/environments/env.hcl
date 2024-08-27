# Environment Configuration File (env.hcl)
#
# This file sets common variables for the environment. 
# It is automatically included in the root `terragrunt.hcl` configuration 
# and propagates these variables to child modules, ensuring consistency 
# across all Terraform deployments in this environment.

locals {
  # GCP Configuration
  project_id=""  # The Google Cloud project ID.
  region="northamerica-northeast2"
  short_region="na-ne2"
  zone1="northamerica-northeast2-a"
  short_zone1="na-ne2-a"

  # Service Account Configuration
  service_account="" # The Google Cloud service account to be impersonated for performing operations.

  # Google Cloud Storage (GCS) Bucket Configuration
  bucket_name="" # The name of the GCS bucket used for storing Terraform state files.

  # Terraform Version
  terraform_version = ">=1.6"

  # Provider Version
  provider_google_version = "5.37.0"
  provider_random         = "3.6.2"
  provider_external       = "2.3.3"
  provider_kubernetes_version = "2.24.0"
}
