variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "Nome do load balancer"
  type        = string
}

variable "backend_type" {
  description = "Tipo de backend"
  type        = string
  default     = "gke"
}

variable "backend_group" {
  description = "Grupo de backends"
  type        = string
  default     = ""
}

variable "enable_cdn" {
  description = "Habilitar CDN"
  type        = bool
  default     = false
}

variable "health_check_port" {
  description = "Porta do health check"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Caminho do health check"
  type        = string
  default     = "/health"
}

