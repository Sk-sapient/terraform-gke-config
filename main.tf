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
  source = "./gke"
}

module "node_pool" {
  source = "./node_pool"
}

module "ingress" {
  source = "./ingress"
}
