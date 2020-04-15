resource "datadog_monitor" "apm" {
  for_each           = var.services
  name               = "Service ${each.key} has a high error rate"
  type               = "query alert"
  message            = "Service ${each.key} has a high error rate. @pagerduty-${each.key}"
  escalation_message = "Service ${each.key} has a high error rate. @pagerduty-${each.key}"

  query = "avg(last_10m):sum:trace.rack.request.errors{env:${var.environment},service:${each.key} } / sum:trace.rack.request.hits{env:${var.environment},service:${each.key} } > ${each.value.critical}"

  thresholds = {
    warning  = each.value.warning
    critical = each.value.critical
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:${each.key}", "env:${var.environment}"]
}