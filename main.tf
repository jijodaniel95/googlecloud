provider "google" {
  region = var.region
  zone   = var.zone
}

resource "google_compute_instance" "vm_instance" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
  }
} 