# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "datadog_api_key" {
  type        = string
  sensitive   = true
  description = "Datadog API key"
}

variable "project_id" {
  type        = string
  description = "GCP default project"
}

variable "zone" {
  type        = string
  description = "GCP Zone to deploy"
  default     = "us-east1-b"
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
