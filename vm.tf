resource "google_compute_instance" "bastion" {
  name         = "bastion-vm"
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  service_account {
    email = google_service_account.service_account.email
    scopes = [ "cloud-platform" ]
  }
  
  depends_on = [
    module.network
  ]
  tags = ["bastion-vm"]
  # image name
  boot_disk {
    initialize_params {
      image = var.machine_image
    }
  }
  # network details
  network_interface {
    network    = module.network.network_name
    subnetwork = module.network.Management_subnet_name
  }

  labels = {
    "name" = "private-vm"
  }

  metadata_startup_script = <<EOF
  #!/bin/bash
  yum install -y tinyproxy
  echo "Allow localhost"| tee -a /etc/tinyproxy/tinyproxy.conf
  systemctl restart tinyproxy
  EOF
}