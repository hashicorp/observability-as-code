# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "ecommerce" {
  count = var.enable_firewall_rule ? 1 : 0

  name    = "allow-ecommerce"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

locals {
  docker_compose = var.fix_frontend ? "fixed" : "broken"
}

resource "google_compute_address" "ecommerce" {
  name = "datadog-webinar-ecommerce"
}

resource "google_compute_instance" "ecommerce" {
  name         = "datadog-webinar-ecommerce"
  machine_type = "n1-standard-2"
  zone         = var.zone

  tags = ["datadog", "webinar"]

  boot_disk {
    initialize_params {
      image = "datadog-ecommerce"
    }
  }

  network_interface {
    network = data.google_compute_network.default.name

    access_config {
      nat_ip = google_compute_address.ecommerce.address
    }
  }

  metadata = {
    partner = "datadog"
    purpose = "webinar"
  }

  metadata_startup_script = <<EOT
    cd /root/ecommerce-workshop/deploy/docker-compose
    POSTGRES_USER=postgres POSTGRES_PASSWORD=postgres DD_API_KEY=${var.datadog_api_key} docker-compose -f docker-compose-${local.docker_compose}-instrumented.yml up -d
    systemctl start gor
  EOT

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

output "ecommerce_frontend" {
  value = "http://${google_compute_instance.ecommerce.network_interface.0.access_config.0.nat_ip}:3000"
}
