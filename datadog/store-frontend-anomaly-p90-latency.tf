# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  critical          = 0.75
  warning           = 0.66
  critical_recovery = 0
}

resource "datadog_monitor" "apm_store_frontend_anomalous_p90_latency" {
  name               = "Service store-frontend has an anomalous p90 latency on ruby-shop"
  type               = "query alert"
  message            = "Service store-fronted has an anomalous p90 latency on ruby-shop."
  escalation_message = "Service store-fronted has an anomalous p90 latency on ruby-shop!!"

  query = "avg(last_1h):anomalies(avg:trace.rack.request.duration.by.service.90p{service:store-frontend,env:ruby-shop}, 'basic', 2, direction='above', interval=20) >= ${local.critical}"

  monitor_thresholds {
    critical          = local.critical
    warning           = local.warning
    critical_recovery = local.critical_recovery
  }

  monitor_threshold_windows {
    trigger_window  = "last_5m"
    recovery_window = "last_10m"
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["service:store-frontend", "env:ruby-shop"]
}
