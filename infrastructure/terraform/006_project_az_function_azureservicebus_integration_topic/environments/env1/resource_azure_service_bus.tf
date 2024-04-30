
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



resource "azurerm_servicebus_subscription" "example" {
  count               = 1
  name                = "${var.prefix}subscription"
  topic_id            = azurerm_servicebus_topic.mtopic.id
  max_delivery_count  = 1
}

resource "azurerm_servicebus_topic" "mtopic" {
  name                = "${var.prefix}topic"
  namespace_id        = azurerm_servicebus_namespace.sb.id 
}