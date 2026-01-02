output "service_account_emails" {
  description = "Emails das service accounts"
  value       = { for sa in google_service_account.accounts : sa.account_id => sa.email }
}

