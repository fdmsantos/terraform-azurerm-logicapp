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
  recurrence_triggers = {
    run-every-day = {
      frequency        = "Day"
      interval         = 1
      time_zone        = "GMT Standard Time"
      at_these_minutes = [0, 30]
      at_these_hours   = [0, 12]
    }
  }
  custom_actions = {
    "Initialize_variable" : file("${path.module}/templates/actions/initialize_variable.json")
  }
  tags = {
    env : "dev"
  }
}
