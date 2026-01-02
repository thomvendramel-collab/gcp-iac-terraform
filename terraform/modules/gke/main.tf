resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  network    = var.network
  subnetwork = var.subnetwork
  
  remove_default_node_pool = true
  initial_node_count       = 1
  
  enable_autopilot = false
  
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }
  
  network_policy {
    enabled = true
  }
  
  addons_config {
    network_policy_config {
      disabled = false
    }
    
    horizontal_pod_autoscaling {
      disabled = false
    }
    
    http_load_balancing {
      disabled = false
    }
  }
  
  release_channel {
    channel = "REGULAR"
  }
  
  resource_labels = {
    environment = var.environment != "" ? var.environment : "unknown"
    managed_by  = "terraform"
  }
}

resource "google_container_node_pool" "pools" {
  count = length(var.node_pools)
  
  name       = var.node_pools[count.index].name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  
  node_count = var.node_pools[count.index].min_count
  
  autoscaling {
    min_node_count = var.node_pools[count.index].min_count
    max_node_count = var.node_pools[count.index].max_count
  }
  
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  
  node_config {
    machine_type = var.node_pools[count.index].machine_type
    disk_size_gb = var.node_pools[count.index].disk_size_gb
    disk_type    = var.node_pools[count.index].disk_type
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    labels = {
      pool = var.node_pools[count.index].name
    }
    
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

