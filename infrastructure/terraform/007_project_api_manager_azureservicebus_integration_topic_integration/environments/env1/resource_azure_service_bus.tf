
resource "azurerm_servicebus_namespace" "sb" {
  name                = "${var.prefix}sb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

}

resource "azurerm_servicebus_namespace_authorization_rule" "sb-ar" {
  name                = "${var.prefix}servicebus_auth_rule"
  namespace_id        = azurerm_servicebus_namespace.sb.id 

  listen = true
  send   = true
  manage = false
}

resource "azurerm_servicebus_topic" "mtopic" {
  name                = "${var.prefix}topic"
  namespace_id        = azurerm_servicebus_namespace.sb.id 
}


resource "azurerm_servicebus_subscription" "example" {
  name                = "${var.prefix}subscription"
  topic_id            = azurerm_servicebus_topic.mtopic.id
  max_delivery_count  = 1
}



# tell API Management how to connect to the Azure Service Bus Topic.
# will use those values in the policy, to redirect api calls in here

resource "azurerm_api_management_named_value" "nv_sb_base_url" {
  name                = "sb-base-url"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  display_name        = "sb-base-url"
  value               = "https://${azurerm_servicebus_namespace.sb.name}.servicebus.windows.net"
}

resource "azurerm_api_management_named_value" "nv_sb_queue" {
  name                = "sb-queue_or_topic"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  display_name        = "sb-queue_or_topic"
  value               = azurerm_servicebus_topic.mtopic.name
}