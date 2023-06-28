#terraform {
#  backend "gcs" {
#    bucket = "utility-helper-state-dev"
#    prefix = "terraform/state"
#  }
#}


module "mongo_cluster" {
  source      = "../../modules/mongo_cluster"
  name        = "dev"
  private_key = var.private_key
  public_key  = var.public_key
  project_id  = var.project_id
}

module "kafka_cluster" {
  source                     = "../../modules/kafka_cluster"
  confluent_cloud_api_key    = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
}

module "kubernetes_cluster" {
  source           = "../../modules/gcp"
  k8s_initial_node = 1
  key_json_path    = var.key_json_path
}