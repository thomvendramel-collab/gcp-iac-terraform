variable "project_id" {
  description = "GCP Project ID onde os recursos serão criados"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID deve seguir o padrão GCP."
  }
}

variable "region" {
  description = "GCP Region principal"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Ambiente de deploy (development, staging, production)"
  type        = string
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment deve ser: development, staging ou production."
  }
}

variable "subnets" {
  description = "Lista de subnets a serem criadas"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
    private_access = bool
  }))
  default = []
}

variable "enable_nat" {
  description = "Habilitar NAT Gateway para subnets privadas"
  type        = bool
  default     = true
}

variable "gke_node_pools" {
  description = "Configuração dos node pools do GKE"
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
    disk_type    = string
  }))
  default = []
}

variable "gke_enable_private_nodes" {
  description = "Usar nodes privados no GKE (sem IPs públicos)"
  type        = bool
  default     = true
}

variable "gke_master_authorized_networks" {
  description = "Redes autorizadas a acessar o master do GKE"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "enable_cloud_sql" {
  description = "Habilitar criação de instância Cloud SQL"
  type        = bool
  default     = false
}

variable "cloud_sql_database_version" {
  description = "Versão do banco de dados (POSTGRES_14, MYSQL_8_0, etc)"
  type        = string
  default     = "POSTGRES_14"
}

variable "cloud_sql_tier" {
  description = "Tier da instância Cloud SQL"
  type        = string
  default     = "db-f1-micro"
}

variable "cloud_sql_backup_enabled" {
  description = "Habilitar backups automáticos"
  type        = bool
  default     = true
}

variable "cloud_sql_backup_start_time" {
  description = "Horário de início dos backups (HH:MM)"
  type        = string
  default     = "03:00"
}

variable "cloud_sql_enable_ha" {
  description = "Habilitar alta disponibilidade (replicação)"
  type        = bool
  default     = false
}

variable "cloud_sql_authorized_networks" {
  description = "Redes autorizadas a acessar o Cloud SQL"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "enable_load_balancer" {
  description = "Habilitar criação de load balancer"
  type        = bool
  default     = false
}

variable "load_balancer_backend_type" {
  description = "Tipo de backend do load balancer (gke, cloud_run, etc)"
  type        = string
  default     = "gke"
}

variable "storage_buckets" {
  description = "Lista de buckets Cloud Storage a serem criados"
  type = list(object({
    name          = string
    location      = string
    storage_class = string
    versioning    = bool
  }))
  default = []
}

variable "service_accounts" {
  description = "Lista de service accounts a serem criadas"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
  }))
  default = []
}

