terraform {
  required_version = "~>0.12"
}

variable "dd_api_key" {}

variable "enable_firewall" {
  default = false
}

variable "fix_frontend" {
  default = true
}

provider "google" {
  version = "~> 3.16"
  zone    = "us-central1-a"
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "ecommerce" {
  count   = var.enable_firewall ? 1 : 0
  name    = "allow-ecommerce"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
}

locals {
  docker_compose = var.fix_frontend ? "fixed" : "broken"
}

resource "google_compute_instance" "default" {
  name         = "datadog-webinar-ecommerce"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["datadog", "webinar"]

  boot_disk {
    initialize_params {
      image = "datadog-ecommerce"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    partner = "datadog"
    purpose = "webinar"
  }

  metadata_startup_script = <<EOT
    cd /root/ecommerce-workshop/docker-compose-files
    POSTGRES_USER=postgres POSTGRES_PASSWORD=postgres DD_API_KEY=${var.dd_api_key} docker-compose -f docker-compose-${local.docker_compose}-instrumented.yml up -d
    systemctl start gor
  EOT

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}