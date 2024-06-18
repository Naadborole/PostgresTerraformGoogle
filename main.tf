provider "google" {
  project     = "postgres-terraform-vector"
  credentials = file("credentials.json")
  region      = "us-west1"
  zone        = "us-west1-a"
}

resource "google_compute_firewall" "rules" {
  project     = "postgres-terraform-vector"
  name        = "allow-postgres-access"
  network     = "default"
  description = "Creates firewall rule to enable tcp at port 5432"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  target_tags   = ["allow-tcp-5432"]
  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_firewall" "rules1" {
  project     = "postgres-terraform-vector"
  name        = "allow-portainer-access"
  network     = "default"
  description = "Creates firewall rule to enable tcp at port 9443"

  allow {
    protocol = "tcp"
    ports    = ["9443"]
  }
  target_tags   = ["allow-tcp-9443"]
  source_ranges = ["0.0.0.0/0"]

}


resource "google_compute_instance" "default" {
  name         = "postgres-db"
  machine_type = "e2-micro"
  zone         = "us-west1-a"
  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240617"
      type  = "pd-standard"
      size  = 20
    }
  }
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/postgres-terraform-vector/regions/us-west1/subnetworks/default"
  }
  tags = ["allow-tcp-5432", "allow-tcp-9443"]
}
