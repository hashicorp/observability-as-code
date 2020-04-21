application = "eCommerce"
services = {
  store-frontend = {
    pd_service_key            = "54321098765432109876"
    environment               = "ruby-shop"
    framework                 = "rack"
    high_error_rate_critical  = 10
    high_error_rate_warning   = 8
    high_avg_latency_critical = 3
    high_avg_latency_warning  = 1
    high_p90_latency_critical = 6
    high_p90_latency_warning  = 4
  }
  advertisements-service = {
    pd_service_key            = "54321098765432109877"
    environment               = "ruby-shop"
    framework                 = "flask"
    high_error_rate_critical  = 10
    high_error_rate_warning   = 8
    high_avg_latency_critical = 3
    high_avg_latency_warning  = 1
    high_p90_latency_critical = 6
    high_p90_latency_warning  = 4
  }
  discounts-service = {
    pd_service_key            = "54321098765432109878"
    environment               = "ruby-shop"
    framework                 = "flask"
    high_error_rate_critical  = 10
    high_error_rate_warning   = 8
    high_avg_latency_critical = 3
    high_avg_latency_warning  = 1
    high_p90_latency_critical = 6
    high_p90_latency_warning  = 4
  }
}
