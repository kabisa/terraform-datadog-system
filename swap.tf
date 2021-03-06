locals {
  swap_percent_free_filter = coalesce(
    var.swap_percent_free_filter_override,
    var.filter_str
  )
}

module "swap_percent_free" {
  source = "git@github.com:kabisa/terraform-datadog-generic-monitor.git?ref=0.6.2"

  name                = "System - Swap percent free"
  query               = "avg(${var.swap_percent_free_evaluation_period}):min:system.swap.pct_free{${local.swap_percent_free_filter}} by {host} * 100 < ${var.swap_percent_free_critical}"
  alert_message       = "Swap memory percent free on ${var.service} Node {{host.name}} is low ({{value}}%))"
  recovery_message    = "Swap memory percent free on ${var.service} Node {{host.name}} has recovered ({{value}}%))"
  require_full_window = false

  # monitor level vars
  enabled            = var.swap_percent_free_enabled
  alerting_enabled   = var.swap_percent_free_alerting_enabled
  warning_threshold  = var.swap_percent_free_warning
  critical_threshold = var.swap_percent_free_critical
  priority           = var.swap_percent_free_priority
  docs               = var.swap_percent_free_docs
  note               = var.swap_percent_free_note

  # module level vars
  env                  = var.alert_env
  service              = var.service
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  locked               = var.locked
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
