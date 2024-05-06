data "azurerm_client_config" "current" {}

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
  workflow_parameters = {
    storage_account_name : {
      type : "String",
      defaultValue : "storageaccountname"
    }
  }
  disable_sas_auth_schema = true
  authentication_policies = {
    test-policy : [
      {
        claim_name : "Issuer",
        claim_value : "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}"
      },
      {
        claim_name : "DummyClaim",
        claim_value : "Dummy Value"
      },
    ]
  }
  custom_triggers = {
    HTTP_Trigger = {
      body = file("${path.module}/templates/triggers/http_trigger.json")
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
