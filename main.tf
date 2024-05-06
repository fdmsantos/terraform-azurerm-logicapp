resource "azurerm_logic_app_workflow" "workflow" {
  name                               = var.name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  integration_service_environment_id = var.integration_service_environment_id
  logic_app_integration_account_id   = var.logic_app_integration_account_id
  workflow_schema                    = var.workflow_schema
  workflow_version                   = var.workflow_version
  workflow_parameters                = local.workflow_parameters
  parameters                         = local.parameters
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type == "BOTH" ? "SystemAssigned, UserAssigned" : var.identity_type
      identity_ids = var.identity_ids
    }
  }
  access_control {
    dynamic "action" {
      for_each = length(var.actions_allowed_caller_ip_address_range) > 0 ? [1] : []
      content {
        allowed_caller_ip_address_range = var.actions_allowed_caller_ip_address_range
      }
    }
    dynamic "trigger" {
      for_each = length(var.triggers_allowed_caller_ip_address_range) > 0 || length(keys(var.authentication_policies)) > 0 ? [1] : []
      content {
        allowed_caller_ip_address_range = var.triggers_allowed_caller_ip_address_range
        dynamic "open_authentication_policy" {
          for_each = var.authentication_policies
          content {
            name = open_authentication_policy.key
            dynamic "claim" {
              for_each = open_authentication_policy.value
              content {
                name  = try(local.standard_claims[claim.value.claim_name], claim.value.claim_name)
                value = claim.value.claim_value
              }
            }
          }
        }
      }
    }
    dynamic "content" {
      for_each = length(var.contents_allowed_caller_ip_address_range) > 0 ? [1] : []
      content {
        allowed_caller_ip_address_range = var.contents_allowed_caller_ip_address_range
      }
    }
    dynamic "workflow_management" {
      for_each = length(var.workflow_management_allowed_caller_ip_address_range) > 0 ? [1] : []
      content {
        allowed_caller_ip_address_range = var.workflow_management_allowed_caller_ip_address_range
      }
    }
  }
  enabled = var.enabled
  tags    = var.tags
}

################## Triggers #################
resource "azurerm_logic_app_trigger_http_request" "this" {
  for_each      = var.http_triggers
  name          = each.key
  logic_app_id  = local.logic_app_id
  schema        = each.value["schema"]
  method        = each.value["method"]
  relative_path = each.value["relative_path"]
}

resource "azurerm_logic_app_trigger_recurrence" "this" {
  for_each     = var.recurrence_triggers
  name         = each.key
  logic_app_id = local.logic_app_id
  frequency    = each.value["frequency"]
  interval     = each.value["interval"]
  start_time   = each.value["start_time"]
  time_zone    = each.value["time_zone"]
  dynamic "schedule" {
    for_each = max(length(each.value["at_these_hours"]), length(each.value["at_these_minutes"]), length(each.value["on_these_days"])) > 0 ? [1] : [0]
    content {
      at_these_minutes = each.value["at_these_minutes"]
      at_these_hours   = each.value["at_these_hours"]
      on_these_days    = each.value["on_these_days"]
    }
  }
}

resource "azurerm_logic_app_trigger_custom" "this" {
  for_each     = local.custom_triggers
  name         = each.key
  logic_app_id = local.logic_app_id
  body         = each.value["body"]
}

################## Actions #################
resource "azurerm_logic_app_action_custom" "this" {
  for_each     = var.custom_actions
  name         = each.key
  logic_app_id = local.logic_app_id
  body         = each.value
}
