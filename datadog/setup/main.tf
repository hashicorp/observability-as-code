# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.57.0"
    }
  }

  required_version = "~>0.13"
}

provider "google" {
  project = var.project
  zone = var.zone
}

variable "dd_api_key" {
  type        = string
  description = "Datadog Agent API key"
}

variable "project" {
  type        = string
  description = "GCP Project"
}

variable "zone" {
  type        = string
  description = "GCP Zone to deploy"
  default     = "us-east1-b"
}

variable "network" {
  type        = string
  description = "GCP VCP to deploy"
  default     = "default"
}

variable "enable_firewall_rule" {
  type        = bool
  description = "Creates firewall rule to allow public traffic"
  default     = true
}

variable "fix_frontend" {
  type        = bool
  description = "Toggle to fix frontend application"
  default     = true
}

resource "google_compute_firewall" "ecommerce" {
  count   = var.enable_firewall_rule ? 1 : 0
  name    = "allow-ecommerce"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
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
    network = var.network

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
    POSTGRES_USER=postgres POSTGRES_PASSWORD=postgres DD_API_KEY=${var.dd_api_key} docker-compose -f docker-compose-${local.docker_compose}-instrumented.yml up -d
    systemctl start gor
  EOT

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

output "ecommerce" {
  value = google_compute_instance.ecommerce.network_interface.0.access_config.0.nat_ip
}
