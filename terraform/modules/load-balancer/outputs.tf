output "ip_address" {
  description = "IP do load balancer"
  value       = google_compute_global_address.lb_ip.address
}

output "url_map" {
  description = "URL map do load balancer"
  value       = google_compute_url_map.url_map.id
}

