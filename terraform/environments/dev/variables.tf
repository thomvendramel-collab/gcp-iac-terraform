variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "subnets" {
  description = "Lista de subnets"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
    private_access = bool
  }))
  default = []
}

variable "gke_node_pools" {
  description = "Node pools do GKE"
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

variable "enable_cloud_sql" {
  description = "Habilitar Cloud SQL"
  type        = bool
  default     = false
}

variable "storage_buckets" {
  description = "Buckets de storage"
  type = list(object({
    name          = string
    location      = string
    storage_class = string
    versioning    = bool
  }))
  default = []
}

variable "service_accounts" {
  description = "Service accounts"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
  }))
  default = []
}

