resource "datadog_integration_pagerduty" "pd" {
  individual_services = true
  schedules = [
    "https://ddog.pagerduty.com/schedules/X123VF"
  ]
  subdomain = "ddog"
  api_token = "38457822378273432587234242874"
}

resource "datadog_integration_pagerduty_service_object" "ecommerce" {
  for_each     = var.services
  depends_on   = [datadog_integration_pagerduty.pd]
  service_name = each.key
  service_key  = each.value.pd_service_key
}