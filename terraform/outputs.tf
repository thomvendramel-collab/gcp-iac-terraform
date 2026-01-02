output "vpc_network_name" {
  description = "Nome da VPC criada"
  value       = module.vpc.network_name
}

output "vpc_network_id" {
  description = "ID da VPC criada"
  value       = module.vpc.network_id
}

output "vpc_subnet_names" {
  description = "Nomes das subnets criadas"
  value       = module.vpc.subnet_names
}

output "gke_cluster_name" {
  description = "Nome do cluster GKE"
  value       = module.gke.cluster_name
}

output "gke_cluster_endpoint" {
  description = "Endpoint do cluster GKE"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "gke_cluster_ca_certificate" {
  description = "Certificado CA do cluster GKE"
  value       = module.gke.cluster_ca_certificate
  sensitive   = true
}

output "cloud_sql_instance_name" {
  description = "Nome da instância Cloud SQL"
  value       = var.enable_cloud_sql ? module.cloud_sql[0].instance_name : null
}

output "cloud_sql_connection_name" {
  description = "Nome de conexão da instância Cloud SQL"
  value       = var.enable_cloud_sql ? module.cloud_sql[0].connection_name : null
  sensitive   = true
}

output "load_balancer_ip" {
  description = "IP do load balancer"
  value       = var.enable_load_balancer ? module.load_balancer[0].ip_address : null
}

output "storage_bucket_names" {
  description = "Nomes dos buckets criados"
  value       = length(var.storage_buckets) > 0 ? module.storage[0].bucket_names : []
}

