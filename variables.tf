variable "resource_group" {
  type        = string
  description = "Resource group name where Automation Account is located"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "automation_account_name" {
  type        = string
  description = "Automation Account name"
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  default     = {}
}

variable "runbook" {
  type = object({
    name         = optional(string),
    description  = optional(string),
    script_path  = optional(string),
    content      = optional(string)
    log_verbose  = optional(bool, true),
    log_progress = optional(bool, true),
    runbook_type = optional(string, "PowerShellWorkflow")
  })
  description = "Objects with parameters to configure Runbook "
}

variable "schedules" {
  type = set(object({
    name        = optional(string),
    description = optional(string),
    frequency   = optional(string, "Week"),
    interval    = optional(string, "1"),
    start_time  = optional(string, null),
    week_days   = optional(list(string), ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])
    parameters  = optional(any, {})
  }))
  description = "Set of objects with parameters to configure Schedules for Runbook"
  default     = []
}
