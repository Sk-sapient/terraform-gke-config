variable "network" {
  description = "The name of the VPC network."
}

variable "subnetwork" {
  description = "The name of the subnetwork."
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = var.network
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.subnetwork
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

