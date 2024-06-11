resource "google_container_cluster" "primary" {
  name                   = var.cluster_name
  location               = var.zone
  remove_default_node_pool = true
  initial_node_count     = 1
  network                = module.vpc.vpc_network.self_link
  subnetwork             = module.vpc.private.self_link
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  networking_mode = "VPC_NATIVE"

  # Other configurations...

  depends_on = [
    module.vpc,
    module.firewall,
    module.router,
    # Add other modules as needed
  ]
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
