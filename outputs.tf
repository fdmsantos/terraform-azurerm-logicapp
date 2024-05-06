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

######################## Triggers ########################
output "http_triggers" {
  description = "Logic App Http Triggers."
  value = {
    for name, trigger in azurerm_logic_app_trigger_http_request.this :
    name => {
      id       = trigger.id
      callback = trigger.callback_url
    }
  }
}

output "recurrence_triggers" {
  description = "Logic App Recurrence Triggers."
  value = {
    for name, trigger in azurerm_logic_app_trigger_recurrence.this :
    name => {
      id = trigger.id
    }
  }
}

output "custom_triggers" {
  description = "Logic App Custom Triggers."
  value = {
    for name, trigger in azurerm_logic_app_trigger_custom.this :
    name => {
      id = trigger.id
    }
  }
}
