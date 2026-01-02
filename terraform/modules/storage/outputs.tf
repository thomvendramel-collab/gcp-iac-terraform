output "bucket_names" {
  description = "Nomes dos buckets"
  value       = [for bucket in google_storage_bucket.buckets : bucket.name]
}

output "bucket_urls" {
  description = "URLs dos buckets"
  value       = [for bucket in google_storage_bucket.buckets : bucket.url]
}

