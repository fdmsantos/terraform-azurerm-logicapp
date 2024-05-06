locals {
  logic_app_id = azurerm_logic_app_workflow.workflow.id
  parameters = merge(var.parameters, length(var.connections_parameters) > 0 ? {
    "$connections" = jsonencode(merge(var.connections_parameters...))
  } : {})
  workflow_parameters = merge(
    { for parameter, content in var.workflow_parameters : parameter => jsonencode(content) },
    length(var.connections_parameters) > 0 ? { "$connections" = jsonencode({ "defaultValue" = {}, "type" = "Object" }) } : {}
  )

  standard_claims = {
    Issuer : "iss"
    Audience : "aud"
    Subject : "sub"
    "JWT ID" : "jti"
  }

  ### Add condition because enable_entra_id_only_option_call_request ###
  custom_triggers_non_http = { for name, trigger in var.custom_triggers : name => trigger if lookup(jsondecode(trigger["body"]), "type", "None") != "Request" && lookup(jsondecode(trigger["body"]), "type", "None") != "HttpWebhook" }
  custom_triggers_http     = { for name, trigger in var.custom_triggers : name => trigger if lookup(jsondecode(trigger["body"]), "type", "None") == "Request" || lookup(jsondecode(trigger["body"]), "type", "None") == "HttpWebhook" }
  custom_triggers_http_entra_id_condition = {
    for name, trigger in local.custom_triggers_http :
    name => {
      body : jsonencode(merge(jsondecode(trigger["body"]), !contains(keys(jsondecode(trigger["body"])), "conditions") ? tomap({
        "conditions" : [{
          "expression" : "@startsWith(triggerOutputs()?['headers']?['Authorization'], 'Bearer')"
          }] }) : tomap({ "conditions" : concat(jsondecode(trigger["body"])["conditions"], [{
            "expression" : "@startsWith(triggerOutputs()?['headers']?['Authorization'], 'Bearer')"
        }]) })
  )) } }
  custom_triggers_http_entra_id_operation_options = {
    for name, trigger in local.custom_triggers_http_entra_id_condition :
    name => {
      body : jsonencode(merge(jsondecode(trigger["body"]), {
        "operationOptions" : "IncludeAuthorizationHeadersInOutputs",
      }))
    }
  }
  custom_triggers = !var.disable_sas_auth_schema ? merge(local.custom_triggers_non_http, local.custom_triggers_http) : merge(local.custom_triggers_non_http, local.custom_triggers_http_entra_id_operation_options)
}
