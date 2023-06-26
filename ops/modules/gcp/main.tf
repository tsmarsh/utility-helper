
provider "google" {
  credentials = file(var.key_json_path)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = var.region

  initial_node_count = var.k8s_initial_node

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags         = ["my-gke-node"]
    preemptible  = false
    machine_type = "n1-standard-1"
  }
}
