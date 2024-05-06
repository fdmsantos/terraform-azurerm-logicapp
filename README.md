# Azure Logic App Terraform Module

[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

Dynamic Terraform module, which creates a Logic App and others resources.

## Table of Contents

* [Module versioning rule](README.md#module-versioning-rule)
* [How to Use](README.md#how-to-use)
    * [Basic](README.md#basic)
* [Examples](README.md#examples)
* [Requirements](README.md#requirements)
* [Providers](README.md#providers)
* [Modules](README.md#modules)
* [Resources](README.md#resources)
* [Inputs](README.md#inputs)
* [Outputs](README.md#outputs)
* [License](README.md#license)

## Module versioning rule

| Module version | Azure Provider version |
|----------------|------------------------|
| >= 1.x.x       | => 3.22                |

## How to Use

### Basic

```hcl
module "logic_app" {
  source              = "fdmsantos/logicapp/azurerm"
  version             = "x.x.x"
  name                = "logicapp-name"
  location            = "westeurope"
  resource_group_name = "<resource-group"
  identity_type       = "SystemAssigned"
  connections_parameters = [
    module.azureblob_api_connection.logic_app_parameter,
    module.sharepoint_api_connection.logic_app_parameter
  ]
  workflow_parameters = {
    storage_account_name : {
      type : "String",
      defaultValue : "storageaccountname"
    }
  }
  http_triggers = {
    "HTTP_Trigger" = {
      method = "POST",
      schema = file("${path.module}/templates/triggers/http_trigger.json")
    }
  }
  recurrence_triggers = {
    run-every-day = {
      frequency        = "Day"
      interval         = 1
    }
  }
  custom_actions = {
    "Initialize_variable" : file("${path.module}/templates/actions/initialize_variable.json")
  }
  tags = {
    env: "dev"
  }
}
```

## Examples

- [complete](https://github.com/fdmsantos/terraform-azurerm-logicapp/tree/main/examples/complete) - Creates Logic App with all supported features.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.22 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_logic_app_action_custom.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_action_custom) | resource |
| [azurerm_logic_app_trigger_custom.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_trigger_custom) | resource |
| [azurerm_logic_app_trigger_http_request.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_trigger_http_request) | resource |
| [azurerm_logic_app_trigger_recurrence.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_trigger_recurrence) | resource |
| [azurerm_logic_app_workflow.workflow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_workflow) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connections_parameters"></a> [connections\_parameters](#input\_connections\_parameters) | Parameters related with API Connections. | `list(map(any))` | `[]` | no |
| <a name="input_custom_actions"></a> [custom\_actions](#input\_custom\_actions) | Map of Logic App Custom Actions. | `map(string)` | `{}` | no |
| <a name="input_custom_triggers"></a> [custom\_triggers](#input\_custom\_triggers) | Map of Custom Triggers. | <pre>map(object({<br>    body = string<br>  }))</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Is the Logic App enabled? Defaults to true | `bool` | `true` | no |
| <a name="input_http_triggers"></a> [http\_triggers](#input\_http\_triggers) | Map of Logic App HTTP Triggers. | <pre>map(object({<br>    schema        = string<br>    method        = optional(string, null)<br>    relative_path = optional(string, null)<br>  }))</pre> | `{}` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Logic App. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be associated with this Logic App. | `string` | `null` | no |
| <a name="input_integration_service_environment_id"></a> [integration\_service\_environment\_id](#input\_integration\_service\_environment\_id) | The ID of the Integration Service Environment to which this Logic App Workflow belongs. Changing this forces a new Logic App Workflow to be created. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the Azure Region where the logic app should exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_logic_app_integration_account_id"></a> [logic\_app\_integration\_account\_id](#input\_logic\_app\_integration\_account\_id) | The ID of the integration account linked by this Logic App Workflow. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Logic App. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A map of Key-Value pairs. Any parameters specified must exist in the Schema defined in workflow\_parameters. | `map(any)` | `{}` | no |
| <a name="input_recurrence_triggers"></a> [recurrence\_triggers](#input\_recurrence\_triggers) | Map of Logic App Recurrence Triggers. | <pre>map(object({<br>    frequency        = string<br>    interval         = number<br>    start_time       = optional(string, null)<br>    time_zone        = optional(string, null)<br>    at_these_minutes = optional(list(number), [])<br>    at_these_hours   = optional(list(number), [])<br>    on_these_days    = optional(list(string), [])<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the name of the Resource Group where the logic should exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_workflow_parameters"></a> [workflow\_parameters](#input\_workflow\_parameters) | Specifies a map of Key-Value pairs of the Parameter Definitions to use for this Logic App Workflow. The key is the parameter name, and the value is a JSON encoded string of the parameter definition (see: https://docs.microsoft.com/azure/logic-apps/logic-apps-workflow-definition-language#parameters). | <pre>map(object({<br>    type          = string<br>    defaultValue  = any<br>    allowedValues = optional(list(string), null)<br>    metadata = optional(object({<br>      description = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_workflow_schema"></a> [workflow\_schema](#input\_workflow\_schema) | Specifies the Schema to use for this Logic App Workflow. Defaults to https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json# | `string` | `"https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"` | no |
| <a name="input_workflow_version"></a> [workflow\_version](#input\_workflow\_version) | Specifies the version of the Schema used for this Logic App Workflow. Defaults to 1.0.0.0. Changing this forces a new resource to be created. | `string` | `"1.0.0.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_endpoint"></a> [access\_endpoint](#output\_access\_endpoint) | The Access Endpoint for the Logic App Workflow. |
| <a name="output_connector_endpoint_ip_addresses"></a> [connector\_endpoint\_ip\_addresses](#output\_connector\_endpoint\_ip\_addresses) | The list of access endpoint IP addresses of connector for the Logic App Workflow. |
| <a name="output_connector_outbound_ip_addresses"></a> [connector\_outbound\_ip\_addresses](#output\_connector\_outbound\_ip\_addresses) | The list of outgoing IP addresses of connector for the Logic App Workflow. |
| <a name="output_custom_triggers"></a> [custom\_triggers](#output\_custom\_triggers) | Logic App Custom Triggers. |
| <a name="output_http_triggers"></a> [http\_triggers](#output\_http\_triggers) | Logic App Http Triggers. |
| <a name="output_id"></a> [id](#output\_id) | The Logic App ID. |
| <a name="output_identity"></a> [identity](#output\_identity) | Logic App Identity |
| <a name="output_recurrence_triggers"></a> [recurrence\_triggers](#output\_recurrence\_triggers) | Logic App Recurrence Triggers. |
| <a name="output_workflow_endpoint_ip_addresses"></a> [workflow\_endpoint\_ip\_addresses](#output\_workflow\_endpoint\_ip\_addresses) | The list of access endpoint IP addresses of workflow for the Logic App Workflow. |
| <a name="output_workflow_outbound_ip_addresses"></a> [workflow\_outbound\_ip\_addresses](#output\_workflow\_outbound\_ip\_addresses) | The list of outgoing IP addresses of workflow for the Logic App Workflow. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/fdmsantos/terraform-azurerm-logicapp/tree/main/LICENSE) for full details.
