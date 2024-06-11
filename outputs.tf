output "cluster_name" {
  value = module.gke.cluster_name
}

output "kubernetes_endpoint" {
  value = module.gke.kubernetes_endpoint
}

output "kubernetes_ca_certificate" {
  value = module.gke.kubernetes_ca_certificate
}


