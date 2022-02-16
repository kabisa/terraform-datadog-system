locals {
  memory_usable_percent_filter = coalesce(
    var.memory_usable_percent_filter_override,
    var.filter_str
  )
}

module "memory_usable_percent" {
  source = "git@github.com:kabisa/terraform-datadog-generic-monitor.git?ref=0.7.0"

  name  = "Memory Usable Percent"
  query = "avg(${var.memory_usable_percent_evaluation_period}):100 * min:system.mem.usable{${local.memory_usable_percent_filter}} by {host} / min:system.mem.total{${local.memory_usable_percent_filter}} by {host} < ${var.memory_usable_percent_critical}"

  # alert specific configuration
  require_full_window = true
  alert_message       = "Usable memory on CloudAMQP Node {{host.name}} has dropped below {{threshold}} and has {{value}}% available"
  recovery_message    = "Usable memory on CloudAMQP Node {{host.name}} has recovered {{value}}%"

  # monitor level vars
  enabled              = var.memory_usable_percent_enabled
  alerting_enabled     = var.memory_usable_percent_alerting_enabled
  warning_threshold    = var.memory_usable_percent_warning
  critical_threshold   = var.memory_usable_percent_critical
  priority             = var.memory_usable_percent_priority
  docs                 = var.memory_usable_percent_docs
  note                 = var.memory_usable_percent_note
  notification_channel = try(coalesce(var.memory_usable_percent_notification_channel_override, var.notification_channel), "")

  # module level vars
  env                  = var.env
  service              = var.service
  service_display_name = var.service_display_name
  additional_tags      = var.additional_tags
  locked               = var.locked
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}