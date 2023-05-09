# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.25"
    }
  }

  required_version = "~> 1.0"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}
