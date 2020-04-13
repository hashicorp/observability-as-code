resource "datadog_integration_pagerduty" "pd" {
  individual_services = true
  schedules = [
    "https://ddog.pagerduty.com/schedules/X123VF"
  ]
  subdomain = "ddog"
  api_token = "38457822378273432587234242874"
}