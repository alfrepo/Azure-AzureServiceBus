
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



resource "azurerm_servicebus_subscription_rule" "rule_session1" {
  name            = "rule_${local.servicebus_session1}"
  subscription_id = azurerm_servicebus_subscription.example.id
  filter_type     = "CorrelationFilter"

  correlation_filter {
    session_id = "${local.servicebus_session1}"
  }
}


resource "azurerm_servicebus_subscription" "example2" {
  name                = "${var.prefix}subscription2"
  topic_id            = azurerm_servicebus_topic.mtopic.id
  max_delivery_count  = 1
}


resource "azurerm_servicebus_subscription_rule" "rule_session2" {
  name            = "rule_${local.servicebus_session2}"
  subscription_id = azurerm_servicebus_subscription.example2.id
  filter_type     = "CorrelationFilter"

  correlation_filter {
    session_id = "${local.servicebus_session2}"
  }
}