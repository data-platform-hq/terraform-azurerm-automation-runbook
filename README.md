# Azure Automation Runbook Terraform module
Terraform module for creation Azure Automation Runbook

## Usage

```hcl
locals {
  current_date_plus_one_day = substr(timeadd(timestamp(),"24h"),0,10)
  
  automation_runbook = {
    
    # Runbook Parameters
    runbook : {
      name        = "VMStartStop"
      description = "Example VM Start/Stop script"
      content = templatefile("../scripts/vm_stop.tftpl", {
        name            = "VMStartStop"
        vm_id           = data.azurerm_virtual_machine.example.id
        subscription_id = data.azurerm_client_config.current.subscription_id
      })
    }
    
    # Parameters of Runbook's Schedules to create
    schedules : [{
      name       = "StartVM"
      start_time = format("%sT09:00:00Z", local.current_date_plus_one_day)
      parameters = {
        action = "start"
      }
    }, {
      name       = "StopVM"
      start_time = format("%sT09:00:00Z", local.current_date_plus_one_day)
      parameters = {
        action = "stop"
      }
    }]
  }
}

data "azurerm_virtual_machine" "example" {
  name                = "vm"
  resource_group_name = "example"
}

data "azurerm_automation_account" "example" {
  name                = "example"
  resource_group_name = "example"
}

module "automation-runbook" {
  source   = "../modules/runbook"

  project                 = var.project
  env                     = var.env
  location                = var.location
  resource_group          = data.azurerm_automation_account.example.resource_group_name
  automation_account_name = data.azurerm_automation_account.example.name

  runbook  = local.automation_runbook.runbook
  schedule = local.automation_runbook.schedules
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                         | Version   |
| ---------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)    | >= 1.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)          | >= 3.40.0 |

## Providers

| Name                                                                   | Version |
| ---------------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)          | 3.40.0  |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)| The name of the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location)| Azure location | `string` | n/a | yes |
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name)| Automation Account name. | `string` | n/a | yes |
| <a name="input_runbook"></a> [runbook](#input\_runbook)| Objects with parameters to configure Runbook |<pre>object({<br>  name         = optional(string),<br>  description  = optional(string),<br>  script_path  = optional(string),<br>  content      = optional(string),<br>  log_verbose  = optional(bool),<br>  log_progress = optional(bool),<br>  runbook_type = optional(string)<br>})</pre> | <pre>({<br>  name         = optional(string),<br>  description  = optional(string),<br>  script_path  = optional(string),<br>  content      = optional(string),<br>  log_verbose  = optional(bool, true),<br>  log_progress = optional(bool, true),<br>  runbook_type = optional(string, "PowerShellWorkflow")<br>})</pre> | no |
| <a name="input_schedules"></a> [schedules](#input\_schedules)| Set of objects with parameters to configure Schedules for Runbook. | <pre>set(object({<br>  name        = optional(string),<br>  description = optional(string),<br>  frequency   = optional(string),<br>  interval    = optional(string),<br>  start_time  = optional(string),<br>  week_days   = optional(list(string)),<br>  parameters  = optional(any, {})<br>}))</pre> | [] | no |
                                                                                                                                                                                                                                                                                                       
## Modules

No modules.

## Resources

| Name                                                                                                                                                                | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_automation_runbook.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook)                               | resource |
| [azurerm_automation_schedule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule)                             | resource |
| [azurerm_automation_job_schedule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule)                     | resource |


## Outputs

| Name                                                                                                                          | Description                                          |
| ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| <a name="output_runbook_id"></a> [runbook\_id](#output\_runbook\_id) | Automation Runbook Id |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-automation-runbook/blob/main/LICENSE)
