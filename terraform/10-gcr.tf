# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "gcr-sa" {
  account_id = "gcr-sa"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "gcr-project" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gcr-sa.email}"
}


resource "google_service_account_key" "gcr-sa-key" {
  service_account_id = google_service_account.gcr-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}


resource "kubernetes_secret" "gcr-secret-production" {
  metadata {
    name = "gcr-secret"
    namespace = kubernetes_namespace.production.id
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
          gcr.io: {
            auth: "_json_key: ${base64decode(google_service_account_key.gcr-sa-key.private_key)}"
        }
      }
    })
  }
}