variable "project" {
  description = "The GCP project ID."
}

variable "network" {
  description = "The name of the VPC network."
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_compute_network" "vpc_network" {
  project                         = var.project
  name                            = var.network
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

resource "google_compute_subnetwork" "private" {
  name          = "private-subnetwork"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.self_link

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/20"
  }
}

output "vpc_network_name" {
  value = google_compute_network.vpc_network.name
}

output "private_subnetwork_name" {
  value = google_compute_subnetwork.private.name
}
