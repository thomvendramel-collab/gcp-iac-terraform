variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "service_accounts" {
  description = "Lista de service accounts"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
  }))
}

