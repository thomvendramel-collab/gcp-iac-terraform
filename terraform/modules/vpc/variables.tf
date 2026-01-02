variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "network_name" {
  description = "Nome da VPC"
  type        = string
}

variable "subnets" {
  description = "Lista de subnets"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
    private_access = bool
  }))
}

variable "enable_nat" {
  description = "Habilitar NAT Gateway"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = ""
}

