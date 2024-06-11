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
  network = var.vpc_network_id
}

module "firewall" {
  source = "./firewall"
  network = var.vpc_network_id
}

module "router" {
  source = "./router"
  network = var.vpc_network_id
  subnetwork = var.subnetwork
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
  network       = var.vpc_network_id
  subnetwork    = var.subnetwork
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
