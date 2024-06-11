resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "kubernetes"
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.zone
  cluster    = module.gke.primary.id
  node_count = var.node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    preemptible  = var.preemptibility
    machine_type = var.machine_type

    labels = {
      env = "dev"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

variable "zone" {
  description = "Zone to deploy resources"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
}

variable "preemptibility" {
  description = "Whether to use preemptible VMs"
  type        = bool
}
