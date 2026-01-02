variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
}

variable "network" {
  description = "Nome da VPC"
  type        = string
}

variable "subnetwork" {
  description = "Nome da subnet"
  type        = string
}

variable "node_pools" {
  description = "Configuração dos node pools"
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
    disk_type    = string
  }))
}

variable "enable_private_nodes" {
  description = "Habilitar nodes privados"
  type        = bool
  default     = true
}

variable "master_authorized_networks" {
  description = "Redes autorizadas para o master"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = ""
}

