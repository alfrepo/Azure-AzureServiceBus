

resource "azurerm_service_plan" "sp" {
  name                = "${var.prefix}-sp"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_application_insights" "example" {
  name                = "${var.prefix}-appinsights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"
}

# resource "azurerm_linux_function_app" "example" {
#   name                       = local.az_function_name
#   location                   = local.location
#   resource_group_name        = azurerm_resource_group.rg.name
#   service_plan_id        = azurerm_service_plan.sp.id
#   storage_account_name       = azurerm_storage_account.storage_account.name
#   storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key

#   identity {
#     type = "SystemAssigned"
#   }

#   site_config {
#     linux_fx_version = "python|3.9"
#   }
# }