output "instance_name" {
  description = "Nome da instância"
  value       = google_sql_database_instance.instance.name
}

output "connection_name" {
  description = "Nome de conexão da instância"
  value       = google_sql_database_instance.instance.connection_name
  sensitive   = true
}

output "ip_address" {
  description = "IP público da instância"
  value       = google_sql_database_instance.instance.public_ip_address
}

output "private_ip_address" {
  description = "IP privado da instância"
  value       = google_sql_database_instance.instance.private_ip_address
}

