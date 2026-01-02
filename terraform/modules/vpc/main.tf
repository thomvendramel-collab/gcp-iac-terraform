resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  
  description = "VPC criada via Terraform para ambiente ${var.environment}"
}

resource "google_compute_subnetwork" "subnets" {
  count = length(var.subnets)
  
  name          = var.subnets[count.index].name
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region        = var.subnets[count.index].region
  network       = google_compute_network.vpc.id
  
  private_ip_google_access = var.subnets[count.index].private_access
  
  description = "Subnet ${var.subnets[count.index].name} na região ${var.subnets[count.index].region}"
}

resource "google_compute_router" "router" {
  count = var.enable_nat ? 1 : 0
  
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
  
  description = "Cloud Router para NAT Gateway"
}

resource "google_compute_router_nat" "nat" {
  count = var.enable_nat ? 1 : 0
  
  name   = "${var.network_name}-nat"
  router = google_compute_router.router[0].name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  
  description = "NAT Gateway para acesso à internet de subnets privadas"
}

