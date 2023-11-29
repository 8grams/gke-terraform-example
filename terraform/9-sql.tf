# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
resource "google_sql_database" "database" {
  name     = "example_db"
  instance = google_sql_database_instance.example-db-instance.name
}

resource "google_compute_global_address" "cloudsql_private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "cloudsql_private_vpc_connection" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloudsql_private_ip_address.name]
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "example-db-instance" {
  name = "example-db-instance"
  region = var.region
  database_version = "POSTGRES_13"

  depends_on = [google_service_networking_connection.cloudsql_private_vpc_connection]

  settings {
    tier = "db-custom-2-7680"
    availability_type = "ZONAL"
    disk_autoresize = true
    disk_size = 10
    disk_type = "PD_SSD"

    backup_configuration {
      enabled = true
      location = var.region
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
      }
    }

    insights_config {
      query_insights_enabled = true
    }

    location_preference {
      zone = "${var.region}-a"
    }
  }

  deletion_protection  = "true"
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "cloudsql" {
  account_id = "cloudsql"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam#google_service_account_iam_policy
resource "google_service_account_iam_binding" "cloudsql_workload_identity" {
  service_account_id = google_service_account.cloudsql.id
  role = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:pmrms-362603.svc.id.goog[production/cloudsql-production]",
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${google_service_account.cloudsql.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
resource "google_sql_user" "user" {
  name = var.cloudsql_username
  instance = google_sql_database_instance.example-db-instance.name
  password = var.cloudsql_password
}