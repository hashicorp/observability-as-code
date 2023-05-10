# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.64.0"
    }
  }

  required_version = "~> 1.0"
}

provider "google" {
  project = var.project_id
  zone    = var.zone
}
