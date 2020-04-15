variable "application" {
  type        = string
  description = "Name of application"
}

variable "environment" {
  type        = string
  description = "Environment tag for APM"
}

variable "services" {
  type = map(object({
    pd_service_key = string,
    critical       = number,
    warning        = number,
  }))
  description = "Services and query alert thresholds"
}