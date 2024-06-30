

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




module "az_function_servicebus_pub1" {

  # ideally keep the modules in an own repository, to have separate pipeline triggers on push
  source               = "../../../modules/az_function_servicebus/v1.0.0"

  location           = local.location
  prefix             = local.prefix
  az_function_name   = "${local.az_function_name}-pub1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  storage_account_name = azurerm_storage_account.storage_account.name
  python_version = local.python_version
  Env_ServiceBusConnection = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
  Env_ServiceBusTopicName = azurerm_servicebus_topic.mtopic.name
  Env_ServiceBusSessionId = local.servicebus_session1
  Env_Subscription = "${azurerm_servicebus_subscription.example.name}" 
  service_plan_id             = "${azurerm_service_plan.sp.id}" 
}

module "az_function_servicebus_con1" {

  # ideally keep the modules in an own repository, to have separate pipeline triggers on push
  source               = "../../../modules/az_function_servicebus/v1.0.0"

  location           = local.location
  prefix             = local.prefix
  az_function_name   = "${local.az_function_name}-con1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  storage_account_name = azurerm_storage_account.storage_account.name
  python_version = local.python_version
  Env_ServiceBusConnection = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
  Env_ServiceBusTopicName = azurerm_servicebus_topic.mtopic.name
  Env_ServiceBusSessionId = local.servicebus_session1
  Env_Subscription = "${azurerm_servicebus_subscription.example.name}" 
  service_plan_id             = "${azurerm_service_plan.sp.id}" 
}


