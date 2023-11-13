# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow-ssh" {
  name = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-http" {
  name = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [ "80", "443" ]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

# for kyverno
# GKE restricts communication between control plane and worker nodes, 
# so we need to set firewall rules to allow control plane communicates with worker node through port 9443
resource "google_compute_firewall" "kyverno-ingress-firewall" {
  name = "allow-ingress-kyverno"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports = [ "9443" ]
  }

  # GKE control plane IP address
  # gcloud container clusters describe ${var.cluster_name} --format='value(privateClusterConfig.masterIpv4CidrBlock)' --region=${var.region}
  source_ranges = [
    "172.16.0.0/28"
  ]
}