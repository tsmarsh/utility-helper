module "mongo_cluster" {
  source = "../../modules/mongo_cluster"
  name = "dev"
  private_key = var.private_key
  public_key = var.public_key
  project_id = var.project_id
}