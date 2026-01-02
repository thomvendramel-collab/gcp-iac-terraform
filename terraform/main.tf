terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_id   = var.project_id
  region       = var.region
  network_name = "${var.environment}-vpc"
  environment  = var.environment
  
  subnets = var.subnets
  
  enable_nat = var.enable_nat
}

# GKE Module
module "gke" {
  source = "./modules/gke"
  
  project_id          = var.project_id
  region              = var.region
  cluster_name        = "${var.environment}-gke-cluster"
  network             = module.vpc.network_name
  subnetwork          = module.vpc.subnet_names[0]
  environment         = var.environment
  
  node_pools          = var.gke_node_pools
  enable_private_nodes = var.gke_enable_private_nodes
  master_authorized_networks = var.gke_master_authorized_networks
  
  depends_on = [module.vpc]
}

# Cloud SQL Module
module "cloud_sql" {
  source = "./modules/cloud-sql"
  
  project_id       = var.project_id
  region           = var.region
  instance_name    = "${var.environment}-postgres"
  database_version = var.cloud_sql_database_version
  tier             = var.cloud_sql_tier
  environment      = var.environment
  
  backup_enabled     = var.cloud_sql_backup_enabled
  backup_start_time  = var.cloud_sql_backup_start_time
  enable_high_availability = var.cloud_sql_enable_ha
  
  authorized_networks = var.cloud_sql_authorized_networks
  
  count = var.enable_cloud_sql ? 1 : 0
}

# Load Balancer Module
module "load_balancer" {
  source = "./modules/load-balancer"
  
  project_id    = var.project_id
  name          = "${var.environment}-lb"
  backend_type  = var.load_balancer_backend_type
  
  depends_on = [module.gke]
  
  count = var.enable_load_balancer ? 1 : 0
}

# Storage Module
module "storage" {
  source = "./modules/storage"
  
  project_id = var.project_id
  buckets    = var.storage_buckets
  
  count = length(var.storage_buckets) > 0 ? 1 : 0
}

# IAM Module
module "iam" {
  source = "./modules/iam"
  
  project_id     = var.project_id
  service_accounts = var.service_accounts
  
  count = length(var.service_accounts) > 0 ? 1 : 0
}

