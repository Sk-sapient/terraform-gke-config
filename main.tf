module "vpc" {
  source = "./vpc"
}

module "firewall" {
  source = "./firewall"
}

module "router" {
  source = "./router"
}

module "gke" {
  source       = "./gke"
  region       = var.region
  zone         = var.zone
  cluster_name = var.cluster_name
}

module "node_pool" {
  source         = "./node_pool"
  zone           = var.zone
  node_count     = var.node_count
  machine_type   = var.machine_type
  preemptibility = var.preemptibility
}

module "ingress" {
  source = "./ingress"
  region = var.region
}

