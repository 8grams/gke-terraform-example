# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = var.project_id
  region = var.region
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_${var.project_id}_${var.zone}_cluster"
}

# https://terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "cluster-tf-state"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 4.0"
    }
  }
}