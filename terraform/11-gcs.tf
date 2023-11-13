# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "example-bucket" {
  name = "example-bucket"
  location = "ASIA-SOUTHEAST2"
  storage_class = "STANDARD"

  uniform_bucket_level_access = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "bucket-sa" {
  account_id = "bucket-sa"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "bucket-im" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.bucket-sa.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_acl
resource "google_storage_bucket_acl" "example-bucket-acl" {
  bucket = google_storage_bucket.example-bucket.name

  role_entity = [
    "OWNER:user-${google_service_account.bucket-sa.email}"
  ]
}