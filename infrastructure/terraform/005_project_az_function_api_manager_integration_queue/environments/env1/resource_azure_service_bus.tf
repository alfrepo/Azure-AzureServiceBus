
resource "azurerm_servicebus_namespace" "sb" {
  name                = "${var.prefix}sb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

}

resource "azurerm_servicebus_queue" "sbq" {
  name                = "${var.prefix}servicebusqueue"
  namespace_id        = azurerm_servicebus_namespace.sb.id 

  enable_partitioning = true
}

resource "azurerm_servicebus_namespace_authorization_rule" "sb-ar" {
  name                = "${var.prefix}servicebus_auth_rule"
  namespace_id        = azurerm_servicebus_namespace.sb.id 

  listen = true
  send   = true
  manage = false
}

