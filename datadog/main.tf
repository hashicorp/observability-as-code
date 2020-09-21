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
