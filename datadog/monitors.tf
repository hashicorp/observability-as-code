resource "datadog_monitor" "apm_service_high_error_rate" {
  for_each           = var.services
  name               = "Service ${each.key} has a high error rate on ${each.value.environment}"
  type               = "query alert"
  message            = "Service ${each.key} has a high error rate. @pagerduty-${each.key}"
  escalation_message = "Service ${each.key} has a high error rate!! @pagerduty-${each.key}"

  query = "avg(last_10m):(sum:trace.${each.value.framework}.request.errors{env:${each.value.environment},service:${each.key} } / sum:trace.${each.value.framework}.request.hits{env:${each.value.environment},service:${each.key} }) > ${each.value.high_error_rate_critical}"


  thresholds = {
    warning  = each.value.high_error_rate_warning
    critical = each.value.high_error_rate_critical
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:${each.key}", "env:${each.value.environment}"]
}

resource "datadog_monitor" "apm_service_high_avg_latency" {
  for_each           = var.services
  name               = "Service ${each.key} has a high average latency on ${each.value.environment}"
  type               = "query alert"
  message            = "Service ${each.key} has a high average latency. @pagerduty-${each.key}"
  escalation_message = "Service ${each.key} has a high average latency!! @pagerduty-${each.key}"

  query = "avg(last_10m):sum:trace.${each.value.framework}.request.duration{env:${each.value.environment},service:${each.key}} / sum:trace.flask.request.hits{env:${each.value.environment},service:${each.key}} > ${each.value.high_avg_latency_critical}"

  thresholds = {
    warning  = each.value.high_avg_latency_warning
    critical = each.value.high_avg_latency_critical
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:${each.key}", "env:${each.value.environment}"]
}

resource "datadog_monitor" "apm_service_high_p90_latency" {
  for_each           = var.services
  name               = "Service ${each.key} has a high p90 latency on ${each.value.environment}"
  type               = "query alert"
  message            = "Service ${each.key} has a high p90 latency. @pagerduty-${each.key}"
  escalation_message = "Service ${each.key} has a high p90 latency!! @pagerduty-${each.key}"

  query = "avg(last_10m):trace.${each.value.framework}.request.duration.by.service.90p{service:${each.key},env:${each.value.environment}} > ${each.value.high_p90_latency_critical}"

  thresholds = {
    warning  = each.value.high_p90_latency_warning
    critical = each.value.high_p90_latency_critical
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:${each.key}", "env:${each.value.environment}"]
}
