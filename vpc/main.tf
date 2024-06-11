resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_compute_network" "vpc_network" {
  name                            = var.network
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

resource "google_compute_subnetwork" "private" {
  name          = "private-subnet"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
}

variable "network" {
  description = "VPC network name"
  type        = string
}
