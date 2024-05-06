variable "name" {
  description = "Specifies the name of the Logic App. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the name of the Resource Group where the logic should exists. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "Specifies the Azure Region where the logic app should exists. Changing this forces a new resource to be created."
  type        = string
}

variable "enabled" {
  description = "Is the Logic App enabled? Defaults to true"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "integration_service_environment_id" {
  description = " The ID of the Integration Service Environment to which this Logic App Workflow belongs. Changing this forces a new Logic App Workflow to be created."
  type        = string
  default     = null
}

variable "logic_app_integration_account_id" {
  description = "The ID of the integration account linked by this Logic App Workflow."
  type        = string
  default     = null
}

variable "workflow_schema" {
  description = "Specifies the Schema to use for this Logic App Workflow. Defaults to https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
  type        = string
  default     = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
}

variable "workflow_version" {
  description = "Specifies the version of the Schema used for this Logic App Workflow. Defaults to 1.0.0.0. Changing this forces a new resource to be created."
  type        = string
  default     = "1.0.0.0"
}

######### Identity #########
variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be associated with this Logic App."
  type        = string
  default     = null
  validation {
    error_message = "Please use a valid source!"
    condition     = var.identity_type == null || can(contains(["SystemAssigned", "UserAssigned", "BOTH"], var.identity_type))
  }
}

variable "identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Logic App."
  type        = list(string)
  default     = []
}

######################## Parameters ########################
variable "parameters" {
  description = "A map of Key-Value pairs. Any parameters specified must exist in the Schema defined in workflow_parameters."
  type        = map(any)
  default     = {}
}

variable "connections_parameters" {
  description = "Parameters related with API Connections."
  type        = list(map(any))
  default     = []
}

variable "workflow_parameters" {
  description = " Specifies a map of Key-Value pairs of the Parameter Definitions to use for this Logic App Workflow. The key is the parameter name, and the value is a JSON encoded string of the parameter definition (see: https://docs.microsoft.com/azure/logic-apps/logic-apps-workflow-definition-language#parameters)."
  type = map(object({
    type          = string
    defaultValue  = any
    allowedValues = optional(list(string), [])
    metadata = optional(object({
      description = optional(string, null)
    }), { })
  }))
  default = {}
}

######################## Triggers ########################
variable "http_triggers" {
  description = "Map of Logic App HTTP Triggers."
  type = map(object({
    schema        = string
    method        = optional(string, null)
    relative_path = optional(string, null)
  }))
  default = {}
}

variable "recurrence_triggers" {
  description = "Map of Logic App Recurrence Triggers."
  type = map(object({
    frequency        = string
    interval         = number
    start_time       = optional(string, null)
    time_zone        = optional(string, null)
    at_these_minutes = optional(list(number), [])
    at_these_hours   = optional(list(number), [])
    on_these_days    = optional(list(string), [])
  }))
  default = {}
}

variable "custom_triggers" {
  description = "Map of Custom Triggers."
  type = map(object({
    body = string
  }))
  default = {}
}

######################## Actions ########################
variable "custom_actions" {
  description = "Map of Logic App Custom Actions."
  type        = map(string)
  default     = {}
}
