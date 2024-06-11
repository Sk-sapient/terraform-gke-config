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
  source  = "./vpc"
  project = var.project
  network = var.network
}

module "firewall" {
  source         = "./firewall"
  vpc_network_id = module.vpc.vpc_network_id
}

module "router" {
  source      = "./router"
  network     = module.vpc.vpc_network_name
  subnetwork  = module.vpc.private_subnetwork_name
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
  network       = module.vpc.vpc_network_name
  subnetwork    = module.vpc.private_subnetwork_name
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
