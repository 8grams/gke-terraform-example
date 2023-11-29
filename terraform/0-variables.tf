variable "project_id" {
  description = "Project ID"
  type = string
  default = "example-project"
}

variable "region" {
  description = "Region of project"
  type = string
  default = "asia-southeast2"
}

variable "zone" {
  description = "Zone of project"
  type = string
  default = "asia-southeast2-a"
}

variable "cloudsql_username" {
  description = "Username for db"
  type = string
  default = "admin"
}

variable "cloudsql_password" {
  description = "Password for db"
  type = string
  default = "secretpassword"
}

variable "cluster_name" {
  description = "k8s Cluster Name"
  type = string
  default = "example-cluster"
}

variable "node_pool_name" {
  description = "k8s Node Pool Name"
  type = string
  default = "example-node-pool"
}