terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.9.0"
    }
  }
}

provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
}

variable "name" {
  default = "dev"
}
resource "mongodbatlas_cluster" "dev-cluster" {
  project_id   = var.project_id
  name         = var.name

  // Provider Settings "block"
  provider_name = "TENANT"
  backing_provider_name = "GCP"
  provider_instance_size_name = "M0"
  provider_region_name        = "CENTRAL_US"
  cluster_type = "REPLICASET"
}

output "mongo_connection" {
  value = mongodbatlas_cluster.dev-cluster.connection_strings[0]
}
