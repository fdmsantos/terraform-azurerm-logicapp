resource "azurerm_resource_group" "this" {
  name     = "RG-${title(var.name)}"
  location = var.location
}

module "logic_app" {
  source              = "../../"
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
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
  custom_actions = {
    "Initialize_variable" : file("${path.module}/templates/actions/initialize_variable.json")
    "Response" : file("${path.module}/templates/actions/response.json")
  }
  tags = {
    env : "dev"
  }
}

################# Api Connections #################
module "azureblob_api_connection" {
  source                        = "fdmsantos/api-connections/azurerm"
  version                       = "1.0.0"
  api_type                      = "azureblob"
  connection_name               = "${var.name}-azureblob"
  deployment_name               = "${var.name}-azureblob-deployment"
  resource_group_name           = azurerm_resource_group.this.name
  connection_display_name       = "${var.name}-azureblob"
  azureblob_authentication_type = "Logic Apps Managed Identity"
}

module "sharepoint_api_connection" {
  source                  = "fdmsantos/api-connections/azurerm"
  version                 = "1.0.0"
  api_type                = "sharepointonline"
  connection_name         = "${var.name}-sharepointonline"
  deployment_name         = "${var.name}-sharepointonline-deployment"
  resource_group_name     = azurerm_resource_group.this.name
  connection_display_name = "${var.name}-sharepointonline"
}