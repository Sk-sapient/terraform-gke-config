provider "google" {
  project = var.project
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "burner-tf-state"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.10.0"
    }
  }
}

module "vpc" {
  source = "./vpc"
  project = var.project
  network = var.network
}

module "firewall" {
  source = "./firewall"
  network = module.vpc.vpc_network.self_link
}

module "router" {
  source = "./router"
  network = module.vpc.vpc_network.self_link
  subnetwork = module.vpc.private_subnetwork.self_link
}

module "gke" {
  source        = "./gke"
  cluster_name  = var.cluster_name
  region        = var.region
  zone          = var.zone
  machine_type  = var.machine_type
  node_count    = var.node_count
  preemptibility = var.preemptibility
  project       = var.project
  network       = module.vpc.vpc_network.self_link
  subnetwork    = module.vpc.private_subnetwork.self_link
}

output "cluster_name" {
  value = module.gke.cluster_name
}

output "kubernetes_endpoint" {
  value = module.gke.kubernetes_endpoint
}

output "kubernetes_ca_certificate" {
  value = module.gke.kubernetes_ca_certificate
}
