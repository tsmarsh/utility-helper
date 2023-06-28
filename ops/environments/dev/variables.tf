variable "public_key" {
  default = ""
}
variable "private_key" {
  default = ""
}

variable "project_id" {
  default = ""
}

variable "confluent_cloud_api_key" {
  default = ""
}
variable "confluent_cloud_api_secret" {
  default = ""
}

variable "key_json_path" {
  default = ""
}

variable "region" {
  default = "us-central1"
}

output "mongo_connection" {
  value = module.mongo_cluster.mongo_connection
}