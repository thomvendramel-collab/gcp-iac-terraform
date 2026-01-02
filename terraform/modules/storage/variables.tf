variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "buckets" {
  description = "Lista de buckets"
  type = list(object({
    name          = string
    location      = string
    storage_class = string
    versioning    = bool
  }))
}

