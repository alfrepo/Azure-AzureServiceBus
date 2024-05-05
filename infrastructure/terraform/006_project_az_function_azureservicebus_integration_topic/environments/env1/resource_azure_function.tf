

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


# resource "azurerm_linux_function_app" "az_func_app_consumer" {
#   name                       = "${local.az_function_name}-con"
#   location                   = local.location
#   resource_group_name        = azurerm_resource_group.rg.name

#   service_plan_id             = azurerm_service_plan.sp.id
#   storage_account_name       = azurerm_storage_account.storage_account.name
#   storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
#   https_only                 = true
#   public_network_access_enabled  = true

#   # sometimes the function deployment failes, when deployed from zero. Keep an eye on it.
#   # if it happens - activate direct upload of zip to blob-container as in commented resource_azure_function_deployzip.tf
#   #zip_deploy_file  = "${path.module}/../../../../../app-006/python-consume/app.zip"


#   identity {
#     type = "SystemAssigned"
#   }

#   auth_settings {
#     enabled          = false
#     unauthenticated_client_action = "AllowAnonymous"
#   }

#   app_settings = {
#       ServiceBusConnection    = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
#   }

#   site_config {
#     application_stack {
#       python_version = local.python_version
#     }
#     cors {
#       allowed_origins = ["https://portal.azure.com"]
#     }
#     application_insights_connection_string = "${azurerm_application_insights.app_insight_con.connection_string}"
#     application_insights_key = "${azurerm_application_insights.app_insight_con.instrumentation_key}"

#   }

#   # provisioner "local-exec" {
#   #   command = "az functionapp deployment source config-zip -g ${azurerm_linux_function_app.az_func_app_consumer.resource_group_name} -n ${azurerm_linux_function_app.az_func_app_consumer.name} --src ${path.module}/../../../../../app-006/python-consume/app.zip"
#   # }

# }



# resource "azurerm_linux_function_app" "az_func_app_publish" {
#   name                       = "${local.az_function_name}-pub"
#   location                   = local.location
#   resource_group_name        = azurerm_resource_group.rg.name

#   service_plan_id             = azurerm_service_plan.sp.id
#   storage_account_name       = azurerm_storage_account.storage_account.name
#   storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
#   https_only                 = true
#   public_network_access_enabled  = true

#   #zip_deploy_file  = "${path.module}/../../../../../app-006/python-publish/app.zip"


#   identity {
#     type = "SystemAssigned"
#   }

#   auth_settings {
#     enabled          = false
#     unauthenticated_client_action = "AllowAnonymous"
#   }

#   app_settings = {
#       ServiceBusConnection    = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
#   }

#   site_config {
#     application_stack {
#       python_version = local.python_version
#     }
#     cors {
#       allowed_origins = ["https://portal.azure.com"]
#     }
#     application_insights_connection_string = "${azurerm_application_insights.app_insight_pub.connection_string}"
#     application_insights_key = "${azurerm_application_insights.app_insight_pub.instrumentation_key}"
#   }

#   # provisioner "local-exec" {
#   #   command = "az functionapp deployment source config-zip -g ${azurerm_linux_function_app.az_func_app_consumer.resource_group_name} -n ${azurerm_linux_function_app.az_func_app_consumer.name} --src ${path.module}/../../../../../app-006/python-publish/app.zip"
#   # }

# }


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


module "az_function_servicebus_pub2" {

  # ideally keep the modules in an own repository, to have separate pipeline triggers on push
  source               = "../../../modules/az_function_servicebus/v1.0.0"

  location           = local.location
  prefix             = local.prefix
  az_function_name   = "${local.az_function_name}-pub2"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  storage_account_name = azurerm_storage_account.storage_account.name
  python_version = local.python_version
  Env_ServiceBusConnection = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
  Env_ServiceBusTopicName = azurerm_servicebus_topic.mtopic.name
  Env_ServiceBusSessionId = local.servicebus_session2
  Env_Subscription = "${azurerm_servicebus_subscription.example.name}" 
  service_plan_id             = "${azurerm_service_plan.sp.id}" 
}

module "az_function_servicebus_con2" {

  # ideally keep the modules in an own repository, to have separate pipeline triggers on push
  source               = "../../../modules/az_function_servicebus/v1.0.0"

  location           = local.location
  prefix             = local.prefix
  az_function_name   = "${local.az_function_name}-con2"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  storage_account_name = azurerm_storage_account.storage_account.name
  python_version = local.python_version
  Env_ServiceBusConnection = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
  Env_ServiceBusTopicName = azurerm_servicebus_topic.mtopic.name
  Env_ServiceBusSessionId = local.servicebus_session2
  Env_Subscription = "${azurerm_servicebus_subscription.example.name}" 
  service_plan_id             = "${azurerm_service_plan.sp.id}" 
}


# # App Insight is created with Workspace Mode 
# resource "azurerm_log_analytics_workspace" "law_fxapp" {
#   name                = "appinsight-law"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = local.location
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

# resource "azurerm_application_insights" "app_insight_pub" {
#   name = "${var.prefix}az_func_app_publish"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = local.location
#   workspace_id = azurerm_log_analytics_workspace.law_fxapp.id
#   application_type    = "web"
# }

# resource "azurerm_application_insights" "app_insight_con" {
#   name = "${var.prefix}az_func_app_consumer"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = local.location
#   workspace_id = azurerm_log_analytics_workspace.law_fxapp.id
#   application_type    = "web"
# }
