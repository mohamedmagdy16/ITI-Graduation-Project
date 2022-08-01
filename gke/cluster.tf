
resource "google_container_cluster" "app_cluster" {
  project  = var.project_id
  name     = "gke-cluster"
  location = "us-central1-a"
 node_locations = [ 
        "us-central1-b"

   ]
#remove default node
  remove_default_node_pool = true
  
#no of nodes in cluster
  initial_node_count       = 1
  depends_on = [
    var.network_name
 ]

#range ips of pods,, range ips of service
  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.pods_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }
  network = var.network_name
  subnetwork = var.subnet_name

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  
# enable cluster is private
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
#update is stable
  release_channel {
      channel = "STABLE"
  }

  ###########access (authorize) vm to gke
    master_authorized_networks_config {
    cidr_blocks {
        cidr_block   = var.master_authorized_networks_config
        display_name = "External Control Plane access"
      }
  }

  addons_config {
    // Enable network policy (Calico)
    network_policy_config {
        disabled = false
      }
  }

  /* Enable network policy configurations (like Calico).
  For some reason this has to be in here twice. */
  network_policy {
    enabled = "true"
  }
#
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Small Linux node pool to run some Linux-only Kubernetes Pods.
resource "google_container_node_pool" "linux_pool" {
  name               = "linux-pool"
  project            = google_container_cluster.app_cluster.project

  cluster            = google_container_cluster.app_cluster.name
  location           = google_container_cluster.app_cluster.location
  
  node_count = 3
  node_config {
    image_type   = "COS_CONTAINERD"
    service_account = google_service_account.gke_sacc.email


  }
}