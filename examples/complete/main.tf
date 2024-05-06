data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

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
  actions_allowed_caller_ip_address_range             = ["${chomp(data.http.myip.response_body)}/32"]
  triggers_allowed_caller_ip_address_range            = ["${chomp(data.http.myip.response_body)}/32"]
  contents_allowed_caller_ip_address_range            = ["${chomp(data.http.myip.response_body)}/32"]
  workflow_management_allowed_caller_ip_address_range = ["${chomp(data.http.myip.response_body)}/32"]
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
      time_zone        = "GMT Standard Time"
      at_these_minutes = [0, 30]
      at_these_hours   = [0, 12]
    }
  }
  custom_triggers = {
    custom = {
      body = <<BODY
  {
    "recurrence": {
      "frequency": "Day",
      "interval": 1
    },
    "type": "Recurrence"
  }
  BODY
    }
  }
  custom_actions = {
    "Initialize_variable" : file("${path.module}/templates/actions/initialize_variable.json")
    #     "Response" : file("${path.module}/templates/actions/response.json") # Does Not work with Recurrence Trigger
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
