variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "instance_name" {
  description = "Nome da instância Cloud SQL"
  type        = string
}

variable "database_version" {
  description = "Versão do banco de dados"
  type        = string
}

variable "tier" {
  description = "Tier da instância"
  type        = string
}

variable "backup_enabled" {
  description = "Habilitar backups"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Horário de início dos backups"
  type        = string
  default     = "03:00"
}

variable "enable_high_availability" {
  description = "Habilitar alta disponibilidade"
  type        = bool
  default     = false
}

variable "authorized_networks" {
  description = "Redes autorizadas"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "private_network" {
  description = "ID da rede privada (opcional)"
  type        = string
  default     = null
}

variable "database_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "appdb"
}

variable "database_user" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "appuser"
}

variable "database_password" {
  description = "Senha do banco de dados (use Secret Manager em produção)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "environment" {
  description = "Ambiente (development, staging, production)"
  type        = string
  default     = "production"
}

