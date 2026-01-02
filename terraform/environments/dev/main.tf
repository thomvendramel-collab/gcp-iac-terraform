module "infrastructure" {
  source = "../../"
  
  project_id   = var.project_id
  region       = var.region
  environment  = "development"
  
  subnets = var.subnets
  enable_nat = true
  
  gke_node_pools = var.gke_node_pools
  gke_enable_private_nodes = false
  
  enable_cloud_sql = var.enable_cloud_sql
  cloud_sql_database_version = "POSTGRES_14"
  cloud_sql_tier = "db-f1-micro"
  
  enable_load_balancer = false
  
  storage_buckets = var.storage_buckets
  service_accounts = var.service_accounts
}

