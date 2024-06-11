resource "google_compute_region_backend_service" "backend_service" {
  name = "backend-service"

  timeout_sec          = 30
  protocol             = "HTTP"
  port_name            = "http"
  enable_cdn           = false
  session_affinity     = "NONE"
  affinity_cookie_ttl_sec = 0

  health_checks = [google_compute_region_health_check.http_health_check.id]
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_region_backend_service.backend_service.self_link
}

resource "google_compute_backend_service" "internal_lb" {
  name = "internal-lb"
  port_name = "http"
  protocol = "HTTP"
  timeout_sec = 30

  health_checks = [google_compute_health_check.http_health_check.id]

  backend {
    group = google_container_node_pool.primary.node_pool_id
  }
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_backend_service.internal_lb.self_link
  port_range = "80"
  load_balancing_scheme = "INTERNAL"
}

resource "google_compute_health_check" "http_health_check" {
  name               = "http-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  tcp_health_check {
    port = 80
  }
}

resource "google_compute_firewall" "internal_lb_firewall" {
  name    = "internal-lb-firewall"
  network = module.vpc.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["10.0.0.0/8"] # Adjust this range to match your VPC CIDR range
}
