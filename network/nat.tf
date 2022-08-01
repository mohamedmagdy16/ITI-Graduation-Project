resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_address" "ipnat" {
  name         = "ipnat"
  project = var.project_id
  region = var.region

}

resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ips = [ google_compute_address.ipnat.self_link ]

  subnetwork {
    name                    = google_compute_subnetwork.Management_Subnet.id
    source_ip_ranges_to_nat = [var.management_subnet_cidr]
  }

  subnetwork { 
     name = google_compute_subnetwork.Restricted_Subnet.id
     source_ip_ranges_to_nat = [ var.restricted_subnet_cidr] # "ALL_IP_RANGES"
  }
}