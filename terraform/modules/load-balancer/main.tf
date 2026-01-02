resource "google_compute_global_address" "lb_ip" {
  name = "${var.name}-ip"
}

resource "google_compute_backend_service" "backend" {
  name                  = "${var.name}-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  enable_cdn            = var.enable_cdn
  load_balancing_scheme = "EXTERNAL"
  
  health_checks = [google_compute_health_check.http.id]
  
  backend {
    group = var.backend_group
  }
  
  log_config {
    enable      = true
    sample_rate = 1.0
  }
}

resource "google_compute_health_check" "http" {
  name               = "${var.name}-health-check"
  check_interval_sec = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
  
  http_health_check {
    port         = var.health_check_port
    request_path = var.health_check_path
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "http_forwarding" {
  name       = "${var.name}-http-forwarding"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.address
}

