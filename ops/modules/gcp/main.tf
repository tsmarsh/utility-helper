provider "google" {
  credentials = file(var.key_json_path)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  initial_node_count       = 1
}