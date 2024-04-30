output "id" {
  description = " The Logic App ID."
  value       = local.logic_app_id
}

output "identity" {
  description = "Logic App Identity"
  value       = azurerm_logic_app_workflow.workflow.identity
}

############## Logic App Workflow Specific Outputs ###############
output "access_endpoint" {
  description = "The Access Endpoint for the Logic App Workflow."
  value       = azurerm_logic_app_workflow.workflow.access_endpoint
}

output "connector_endpoint_ip_addresses" {
  description = "The list of access endpoint IP addresses of connector for the Logic App Workflow."
  value       = azurerm_logic_app_workflow.workflow.connector_endpoint_ip_addresses
}

output "connector_outbound_ip_addresses" {
  description = "The list of outgoing IP addresses of connector for the Logic App Workflow."
  value       = azurerm_logic_app_workflow.workflow.connector_outbound_ip_addresses
}

output "workflow_endpoint_ip_addresses" {
  description = "The list of access endpoint IP addresses of workflow for the Logic App Workflow."
  value       = azurerm_logic_app_workflow.workflow.workflow_endpoint_ip_addresses
}

output "workflow_outbound_ip_addresses" {
  description = "The list of outgoing IP addresses of workflow for the Logic App Workflow."
  value       = azurerm_logic_app_workflow.workflow.workflow_outbound_ip_addresses
}
