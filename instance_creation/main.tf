# Unified Terraform Template: Secure GCP Infra (Free Tier-Friendly)

# ------------------------------------------
# REQUIRED VARIABLES (Replace as needed)
# ------------------------------------------
variable "project_id" {}
variable "region"     { default = "us-central1" }
variable "zone"       { default = "us-central1-c" }

# ------------------------------------------
# PROVIDER SETUP
# ------------------------------------------
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# ------------------------------------------
# VPC & SUBNETS
# ------------------------------------------
resource "google_compute_network" "main_vpc" {
  name                    = "secure-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main_subnet" {
  name                     = "main-subnet"
  ip_cidr_range            = "10.0.0.0/16"
  region                   = var.region
  network                  = google_compute_network.main_vpc.id
  private_ip_google_access = true
}

# ------------------------------------------
# FIREWALL RULES
# ------------------------------------------
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["http-server", "https-server"]
  direction     = "INGRESS"
  priority      = 1000
}

# ------------------------------------------
# FREE TIER VM (e2-micro, ephemeral disk, minimal config)
# ------------------------------------------
resource "google_compute_instance" "free_tier_vm" {
  name         = "free-tier-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10 # 10 GB to stay within 30 GB-month free tier
    }
  }

  network_interface {
    subnetwork   = google_compute_subnetwork.main_subnet.name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

resource "google_service_account" "vm_sa" {
  account_id   = "vm-service-account"
  display_name = "VM Service Account"
}

# ------------------------------------------
# GKE Autopilot Cluster (Free-tier eligible usage)
# ------------------------------------------
resource "google_container_cluster" "autopilot" {
  name     = "autopilot-cluster"
  location = var.region
  enable_autopilot = true
  networking_mode  = "VPC_NATIVE"
  network    = google_compute_network.main_vpc.name
  subnetwork = google_compute_subnetwork.main_subnet.name
}

# ------------------------------------------
# OUTPUTS
# ------------------------------------------
output "vm_external_ip" {
  value = google_compute_instance.free_tier_vm.network_interface[0].access_config[0].nat_ip
}

output "gke_cluster_name" {
  value = google_container_cluster.autopilot.name
}

output "vpc_name" {
  value = google_compute_network.main_vpc.name
}
