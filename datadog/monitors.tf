resource "datadog_monitor" "apm_service_high_error_rate" {
  for_each           = var.services
  name               = "Service ${each.key} has a high error rate on ${var.environment}"
  type               = "query alert"
  message            = "Service ${each.key} has a high error rate. @pagerduty-${each.key}"
  escalation_message = "Service ${each.key} has a high error rate!! @pagerduty-${each.key}"

  query = "avg(last_10m):sum:trace.rack.request.errors{env:${var.environment},service:${each.key} } / sum:trace.rack.request.hits{env:${var.environment},service:${each.key} } > ${each.value.critical}"

  thresholds = {
    warning  = each.value.high_error_rate_warning
    critical = each.value.high_error_rate_critical
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:${each.key}", "env:${var.environment}"]
}

resource "datadog_monitor" "apm_service_high_avg_latency" {
  for_each           = var.services
  name               = "Service ${each.key} has a high average latency on ${var.environment}"
  type               = "query alert"
  message            = "Service ${each.key} has a high average latency. @pagerduty-${each.key}"
  escalation_message = "Service ${each.key} has a high average latency!! @pagerduty-${each.key}"

  query = "( sum:trace.rack.request.duration{service:${each.key},env:${var.environment}}.rollup(sum).fill(zero) / sum:trace.rack.request.hits{service:${each.key},env:${var.environment}}.rollup(sum).fill(zero) )"

  thresholds = {
    warning  = each.value.high_avg_latency_warning
    critical = each.value.high_avg_latency_critical
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:${each.key}", "env:${var.environment}"]
}

resource "datadog_monitor" "apm_service_high_p90_latency" {
  for_each           = var.services
  name               = "Service ${each.key} has a high p90 latency on ${var.environment}"
  type               = "query alert"
  message            = "Service ${each.key} has a high p90 latency. @pagerduty-${each.key}"
  escalation_message = "Service ${each.key} has a high p90 latency!! @pagerduty-${each.key}"

  query = "avg:trace.rack.request.duration.by.service.90p{service:${each.key},env:${var.environment}}"

  thresholds = {
    warning  = each.value.high_p90_latency_warning
    critical = each.value.high_p90_latency_critical
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:${each.key}", "env:${var.environment}"]
}

