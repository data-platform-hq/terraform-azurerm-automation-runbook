locals {
  mapped_schedules = {
    for i in var.schedules : i.name => i
    if i.name != null
  }
}

resource "azurerm_automation_runbook" "this" {
  name                    = var.runbook.name
  location                = var.location
  resource_group_name     = var.resource_group
  automation_account_name = var.automation_account_name
  log_verbose             = var.runbook.log_verbose
  log_progress            = var.runbook.log_progress
  description             = var.runbook.description
  runbook_type            = var.runbook.runbook_type
  content                 = var.runbook.content
}

resource "azurerm_automation_schedule" "this" {
  for_each = local.mapped_schedules

  name                    = each.value.name
  resource_group_name     = var.resource_group
  automation_account_name = var.automation_account_name
  frequency               = each.value.frequency
  interval                = each.value.interval
  start_time              = each.value.start_time
  description             = each.value.description
  week_days               = each.value.week_days

  lifecycle {
    ignore_changes = [start_time]
  }
}

resource "azurerm_automation_job_schedule" "this" {
  for_each = local.mapped_schedules

  resource_group_name     = var.resource_group
  automation_account_name = var.automation_account_name
  schedule_name           = azurerm_automation_schedule.this[each.key].name
  runbook_name            = azurerm_automation_runbook.this.name
  parameters              = each.value.parameters
}
