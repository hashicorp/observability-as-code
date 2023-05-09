# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "datadog_api_key" {
  type        = string
  sensitive   = true
  description = "Datadog API key"
}

variable "datadog_app_key" {
  type        = string
  sensitive   = true
  description = "Datadog APP key"
}

variable "datadog_api_url" {
  type        = string
  description = "Datadog API URL. See https://docs.datadoghq.com/getting_started/site/ for all available regions."
  default     = "https://app.datadoghq.com"

  validation {
    condition     = contains(["https://app.datadoghq.com", "https://us3.datadoghq.com", "https://us5.datadoghq.com", "https://app.datadoghq.eu", "https://app.ddog-gov.com", "https://ap1.datadoghq.com"], var.datadog_api_url)
    error_message = "The configured Datadog APP url is invalid."
  }
}

variable "application" {
  type        = string
  description = "Name of application"
}

variable "services" {
  type = map(object({
    pd_service_key            = string,
    environment               = string,
    framework                 = string,
    high_error_rate_warning   = number,
    high_error_rate_critical  = number,
    high_avg_latency_warning  = number,
    high_avg_latency_critical = number,
    high_p90_latency_warning  = number,
    high_p90_latency_critical = number,
  }))
  description = "Services and query alert thresholds"
}
