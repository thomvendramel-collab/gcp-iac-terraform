resource "google_storage_bucket" "buckets" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }
  
  name          = each.value.name
  location      = each.value.location
  storage_class = each.value.storage_class
  
  versioning {
    enabled = each.value.versioning
  }
  
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
  
  uniform_bucket_level_access = true
  
  labels = {
    managed_by = "terraform"
  }
}

