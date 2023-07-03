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


resource "mongodbatlas_cluster" "cluster" {
  project_id   = var.project_id
  name         = var.name

  // Provider Settings "block"
  provider_name = "TENANT"
  backing_provider_name = var.mongo_cloud_provider
  provider_instance_size_name = var.mongo_cloud_instance_size
  provider_region_name        = var.mongo_cloud_region
  cluster_type = "REPLICASET"
}

resource "mongodbatlas_database_user" "user" {
  project_id   = var.project_id
  username     = var.mongo_user
  password     = var.mongo_password

  auth_database_name = "admin" # The database the user should authenticate against.

  roles {
    role_name     = "readWrite"
    database_name = var.mongo_db_name
  }

  depends_on = [mongodbatlas_cluster.cluster]
}

output "mongo_connection" {
  value = mongodbatlas_cluster.cluster.connection_strings[0]
}
