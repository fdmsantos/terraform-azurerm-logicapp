locals {
  logic_app_id = azurerm_logic_app_workflow.workflow.id
  parameters = merge(var.parameters, length(var.connections_parameters) > 0 ? {
    "$connections" = jsonencode(merge(var.connections_parameters...))
  } : {})
  workflow_parameters = merge(
    { for parameter, content in var.workflow_parameters : parameter => jsonencode(content) },
    length(var.connections_parameters) > 0 ? { "$connections" = jsonencode({ "defaultValue" = {}, "type" = "Object" }) } : {}
  )
}
