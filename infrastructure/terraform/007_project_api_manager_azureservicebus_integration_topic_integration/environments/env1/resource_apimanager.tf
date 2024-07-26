# API Management Service
resource "azurerm_api_management" "app" {
  name                = "${local.prefix}-example-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_named_value" "example" {
  name                = "example-apimg"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  display_name        = "ExampleProperty"
  value               = "Example Value"
}


# correct is :
#https://alfdevapi3-example-apim.azure-api.net/alfdevapi3alfdevfunction-func/http_trigger
# question: how to decouple frontend-name from backend-name?

resource "azurerm_api_management_api" "mapi" {
  name                = "${local.prefix}-example-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  revision            = "1"
  display_name        = "Example API"
  #path                = module.az_function_servicebus_pub1.thename #TODO use the func ref
  path                = "hohosomemypathalf"
  protocols           = ["https"]

}

## link the API Management to the Azure Service Bus. 
# First, allow the API Management to access the Azure Service Bus Topic:

resource "azurerm_role_assignment" "apim_role_assignment" {
  scope                =  "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}"
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_api_management.app.identity.0.principal_id
  depends_on           = [azurerm_api_management.app]
}

