provider "google" {
  project     = "hari-cloud-first-project"
  region      = "us-central1"
}

resource "google_compute_network" "vpc-auto" {
  name                    = "vpc-network-auto"
  auto_create_subnetworks = true
}
resource "google_compute_firewall" "enable-vpc-auto-fw" {
  name    = "enable-vpc-auto-fw"
  network = google_compute_network.vpc-auto.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags = ["web"]
}

resource "google_compute_network" "vpc-custom" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "vpc-custom-subnet" {
  name          = "vpc-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc-custom.name
}
resource "google_compute_firewall" "enable-vpc-custom-fw" {
  name    = "enable-vpc-custom-fw"
  network = google_compute_network.vpc-custom.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags = ["web"]
}

resource "google_compute_network" "vpc1-custom" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "vpc1-custom-subnet" {
  name          = "vpc1-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc1-custom.name
}
resource "google_compute_firewall" "enable-vpc1-custom-fw" {
  name    = "enable-vpc1-custom-fw"
  network = google_compute_network.vpc1-custom.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags = ["web"]
}

resource "google_compute_instance" "default" {
  name         = "instance-vpc-auto"
  machine_type = "e2-medium"
  zone        = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.vpc-auto.name

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_compute_instance" "default" {
  name         = "instance-vpc-custom"
  machine_type = "e2-medium"
  zone        = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    network = google_compute_network.vpc-custom.name
    subnetwork = google_compute_subnetwork.vpc-custom-subnet.name

    access_config {
      // Ephemeral public IP
    }
  }
}
resource "google_compute_instance" "default" {
  name         = "instance-vpc1-custom"
  machine_type = "e2-medium"
  zone        = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    network = google_compute_network.vpc1-custom.name
    subnetwork = google_compute_subnetwork.vpc1-custom-subnet.name

    access_config {
      // Ephemeral public IP
    }
  }
}


