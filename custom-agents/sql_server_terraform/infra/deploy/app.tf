# Terraform Configuration for Google Cloud Storage Bucket, Service Account for
# Cloud SQL Proxy, and Kubernetes Secret
#
# This Terraform configuration:
# - Creates a Google Cloud Storage (GCS) bucket with a lifecycle rule to delete
#   objects after 3 days if they are in the STANDARD storage class.
# - Creates a service account with the necessary permissions to access both
#   the GCS bucket and Cloud SQL instances.
# - Saves the service account key and database credentials into a Kubernetes
#   secret.
#
# Copyright 2024 Translucent Computing Inc.

# Google Cloud Storage Bucket Resource
resource "google_storage_bucket" "app_export_bucket" {
  name          = var.kubert_assistant_app_bucket
  location      = var.region
  force_destroy = true                              # Force deletion of the bucket even if it contains objects

  uniform_bucket_level_access = true  # Enables uniform bucket-level access for better security management

  versioning {
    enabled = false   # Disables versioning of objects in the bucket
  }

  lifecycle_rule {
    action {
      type = "Delete"   # Action to delete objects
    }

    condition {
      age = 3                         # Condition to apply the action to objects 3 days old or older
      matches_storage_class = ["STANDARD"]  # Applies the rule only to objects in the STANDARD storage class
    }
  }
}


# Create service account for Cloud SQL proxy
module "sa" {
  source            = "../../../../../../../modules/iam_service_account"
  project_id        = var.project_id
  name              = "cloudsql-application-sa"
  generate_key      = true
  iam_project_roles = {
    "${var.project_id}" = [
      "roles/cloudsql.client",
      "roles/cloudsql.instanceUser"
    ]
  }
  iam_storage_roles = {
    "${google_storage_bucket.app_export_bucket.name}" = ["roles/storage.objectAdmin"]
  }
}

# Save the Service Account Key into Kubernetes Secret
resource "kubernetes_secret" "sa" {
  metadata {
    name      = var.kube_database_secret
    namespace = data.terraform_remote_state.gke_man_after.outputs.kubert_assistant_namespace
  }
  data = {
    "credentials.json" = base64decode(module.sa.key.private_key)
    "db_user" = var.cloud_sql_instance_sql_users.username
    "db_pass" = data.google_secret_manager_secret_version.assistant_password.secret_data
  }
}

# Grant public read access to the bucket
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.app_export_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
