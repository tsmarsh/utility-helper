variable "public_key" {
  default = ""
}
variable "private_key" {
  default = ""
}

variable "project_id" {
  default = ""
}

variable "name" {
  default = "dev"
}

variable "mongo_cloud_provider" {
  default = "GCP"
}
variable "mongo_cloud_instance_size" {
  default = "M0"
}
variable "mongo_cloud_region" {
  default = "CENTRAL_US"
}

variable "mongo_user" {
  default = "lloyd"
}

variable "mongo_password" {
  default = ""
}

variable "mongo_db_name" {
  default = "dev"
}