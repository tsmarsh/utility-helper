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

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "the-replaceables"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"
  }
}


output "host" {
  value     = google_container_cluster.primary.endpoint
  sensitive = true
}

output "client_token" {
  value     = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.primary.master_auth.0.client_certificate
  sensitive = true
}

output "client_certificate" {
  value     = google_container_cluster.primary.master_auth.0.client_key
  sensitive = true
}

output "client_key" {
  value     = google_container_cluster.primary.master_auth.0.client_key
  sensitive = true
}

resource "local_sensitive_file" "kubeconfig" {
  content = <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}
    server: https://${google_container_cluster.primary.endpoint}
  name: primary
contexts:
- context:
    cluster: primary
    user: my-cluster-admin
  name: primary
current-context: primary
kind: Config
preferences: {}
users:
- name: my-cluster-admin
  user:
    client-certificate-data: ${google_container_cluster.primary.master_auth.0.client_certificate}
    client-key-data: ${google_container_cluster.primary.master_auth.0.client_key}
EOF
  filename = "${path.module}/kubeconfig"
  file_permission = "0600"
}
