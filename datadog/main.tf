terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "2.12.1"
    }
  }

  required_version = "~>0.13"
}

provider "datadog" {}
