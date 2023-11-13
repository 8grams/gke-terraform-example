# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name = "private"
  ip_cidr_range = "10.0.0.0/18"
  region = var.region
  network = google_compute_network.main.id
  private_ip_google_access = true
  
  secondary_ip_range {
    range_name    = "k8s-pods-ip-range"
    ip_cidr_range = "10.28.0.0/14"
  }
  
  secondary_ip_range {
    range_name    = "k8s-services-ip-range"
    ip_cidr_range = "10.32.0.0/20"
  }
}