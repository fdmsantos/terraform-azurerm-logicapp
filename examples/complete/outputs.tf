output "logic_app_id" {
  description = "The Logic App ID."
  value       = module.logic_app.id
}

output "http_triggers" {
  description = "Http Triggers."
  value       = module.logic_app.http_triggers
}

output "recurrence_triggers" {
  description = "Recurrence Triggers."
  value       = module.logic_app.recurrence_triggers
}

output "custom_triggers" {
  description = "Custom Triggers."
  value       = module.logic_app.custom_triggers
}
