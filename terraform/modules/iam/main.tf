resource "google_service_account" "accounts" {
  for_each = { for sa in var.service_accounts : sa.account_id => sa }
  
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = "Service account criada via Terraform"
}

resource "google_project_iam_member" "roles" {
  for_each = {
    for pair in flatten([
      for sa in var.service_accounts : [
        for role in sa.roles : {
          key  = "${sa.account_id}-${role}"
          sa   = sa.account_id
          role = role
        }
      ]
    ]) : pair.key => pair
  }
  
  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.accounts[each.value.sa].email}"
}

