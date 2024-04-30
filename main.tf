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
  enabled = var.enabled
  tags    = var.tags
}

resource "azurerm_logic_app_trigger_http_request" "this" {
  for_each      = var.http_triggers
  name          = each.key
  logic_app_id  = local.logic_app_id
  schema        = each.value["schema"]
  method        = each.value["method"]
  relative_path = each.value["relative_path"]
}

resource "azurerm_logic_app_action_custom" "this" {
  for_each     = var.custom_actions
  name         = each.key
  logic_app_id = local.logic_app_id
  body         = each.value
}
