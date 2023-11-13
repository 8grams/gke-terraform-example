resource "kubernetes_service_account" "cloudsql-production" {
  metadata {
    name = "cloudsql-production"
    namespace = kubernetes_namespace.production.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.cloudsql.account_id}@${var.project_id}.iam.gserviceaccount.com"
    }
  }
}

resource "kubernetes_service_account" "cloudsql-staging" {
  metadata {
    name = "cloudsql-staging"
    namespace = kubernetes_namespace.staging.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.cloudsql.account_id}@${var.project_id}.iam.gserviceaccount.com"
    }
  }
}