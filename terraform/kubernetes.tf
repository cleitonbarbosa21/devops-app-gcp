# Cluster GKE
resource "google_container_cluster" "devops_cluster" {
  name     = "devops-cluster"
  location = var.region

  node_locations = [
    "${var.region}-a",
    "${var.region}-b"
  ]

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# Node Pool
resource "google_container_node_pool" "devops_nodes" {
  name       = "devops-node-pool"
  location   = var.region
  cluster    = google_container_cluster.devops_cluster.name
  node_count = 1 # Reduzir de 2 para 1 nó

  node_config {
    preemptible  = true
    machine_type = "e2-small"    # Usar e2-small em vez de e2-medium
    disk_size_gb = 20            # Adicionar tamanho específico menor
    disk_type    = "pd-standard" # Usar disco padrão em vez de SSD

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["gke-node"]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2 # Reduzir máximo também
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}