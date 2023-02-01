# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "2.13.0"
    }
  }

  required_version = "~> 0.13"
}

provider "datadog" {}
