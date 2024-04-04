

resource "azurerm_service_plan" "sp" {
  name                = "${var.prefix}-sp"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  # https://learn.microsoft.com/en-us/cli/azure/appservice/plan?view=azure-cli-latest
  # https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans
  # https://azure.microsoft.com/en-us/pricing/details/functions/
  sku_name            = "Y1" #consumption plan - billed on a per second basis
#  sku_name            = "B1" # Basic small dedicated plan, scalable
}

# resource "azurerm_application_insights" "az_func_insights" {
#   name                = "${var.prefix}-appinsights"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   application_type    = "web"
# }

resource "azurerm_linux_function_app" "az_func_app" {
  name                       = local.az_function_name
  location                   = local.location
  resource_group_name        = azurerm_resource_group.rg.name

  service_plan_id             = azurerm_service_plan.sp.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  https_only                 = true
  public_network_access_enabled  = true

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled          = false
    unauthenticated_client_action = "AllowAnonymous"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
}