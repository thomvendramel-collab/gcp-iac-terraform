output "network_name" {
  description = "Nome da VPC"
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "ID da VPC"
  value       = google_compute_network.vpc.id
}

output "subnet_names" {
  description = "Nomes das subnets"
  value       = google_compute_subnetwork.subnets[*].name
}

output "subnet_ids" {
  description = "IDs das subnets"
  value       = google_compute_subnetwork.subnets[*].id
}

