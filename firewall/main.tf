resource "google_compute_firewall" "gke_firewall" {
  name    = "test-firewall"
  network = module.vpc.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
