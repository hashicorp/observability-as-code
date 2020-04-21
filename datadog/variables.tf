variable "application" {
  type        = string
  description = "Name of application"
}

variable "services" {
  type = map(object({
    pd_service_key            = string,
    environment               = string,
    high_error_rate_warning   = number,
    high_error_rate_critical  = number,
    high_avg_latency_warning  = number,
    high_avg_latency_critical = number,
    high_p90_latency_warning  = number,
    high_p90_latency_critical = number,
  }))
  description = "Services and query alert thresholds"
}