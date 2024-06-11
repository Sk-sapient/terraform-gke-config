variable "cluster_name" {
  description = "GKE cluster name"
}

variable "region" {
  description = "Region to deploy resources"
}

variable "zone" {
  description = "Zone to deploy resources"
}

variable "machine_type" {
  description = "Machine type for nodes"
}

variable "node_count" {
  description = "Number of nodes in the node pool"
}

variable "preemptibility" {
  description = "Whether to use preemptible VMs"
}

variable "project" {
  description = "GCP project"
}

variable "network" {
  description = "The name of the VPC network."
}

variable "subnetwork" {
  description = "The name of the subnetwork."
}

resource "google_container_cluster" "primary" {
  name                   = var.cluster_name
  location               = var.zone
  remove_default_node_pool = true
  initial_node_count     = 1
  network                = var.network
  subnetwork             = var.subnetwork

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  ip_allocation_policy {
    use_ip_aliases = true
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  depends_on = [
    module.vpc,
    module.firewall,
    module.router
  ]
}

resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Kubernetes Service Account"
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.id
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

  depends_on = [google_service_account.kubernetes]
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubernetes_endpoint" {
  value = google_container_cluster.primary.private_endpoint
}

output "kubernetes_ca_certificate" {
  value = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}
