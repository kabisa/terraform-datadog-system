locals {
  memory_free_bytes_filter = coalesce(
    var.memory_free_bytes_filter_override,
    var.filter_str
  )
}

module "memory_free_bytes" {
  source = "git@github.com:kabisa/terraform-datadog-generic-monitor.git?ref=0.6.2"

  name             = "System - Memory Free Bytes"
  query            = "avg(${var.memory_free_bytes_evaluation_period}):min:system.mem.free{${local.memory_free_bytes_filter}} by {host} < ${var.memory_free_bytes_critical}"
  alert_message    = "Available memory on ${var.service} Node {{host.name}} has dropped below {{threshold}} and has {{value}} available"
  recovery_message = "Available memory on ${var.service} Node {{host.name}} has recovered {{value}}"

  # monitor level vars
  enabled            = var.memory_free_bytes_enabled
  alerting_enabled   = var.memory_free_bytes_alerting_enabled
  warning_threshold  = var.memory_free_bytes_warning
  critical_threshold = var.memory_free_bytes_critical
  priority           = var.memory_free_bytes_priority
  docs               = var.memory_free_bytes_docs
  note               = var.memory_free_bytes_note

  # module level vars
  env                  = var.alert_env
  service              = var.service
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  locked               = var.locked
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
