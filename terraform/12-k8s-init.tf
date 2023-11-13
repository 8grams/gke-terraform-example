# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
resource "kubernetes_namespace" "production" {
  metadata {
    name = "production"
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "ingress-nginx"
  }
}
