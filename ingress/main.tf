resource "google_compute_address" "static_ip" {
  name         = "ingress-static-ip"
  region       = var.region
  address_type = "EXTERNAL"
}

resource "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "cloud.google.com/load-balancer-type" = "External"
    }
  }

  spec {
    type = "LoadBalancer"
    load_balancer_ip = google_compute_address.static_ip.address
    ports {
      port        = 80
      target_port = 80
    }
    ports {
      port        = 443
      target_port = 443
    }
    selector = {
      app = "nginx-ingress"
    }
  }
}

resource "kubernetes_deployment" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "kube-system"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx-ingress"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-ingress"
        }
      }

      spec {
        container {
          name  = "nginx-ingress-controller"
          image = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.
