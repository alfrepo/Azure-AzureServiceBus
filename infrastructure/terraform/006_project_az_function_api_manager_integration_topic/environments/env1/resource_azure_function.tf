

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


resource "azurerm_linux_function_app" "az_func_app_consumer" {
  name                       = "${local.az_function_name}-con"
  location                   = local.location
  resource_group_name        = azurerm_resource_group.rg.name

  service_plan_id             = azurerm_service_plan.sp.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  https_only                 = true
  public_network_access_enabled  = true

  # sometimes the function deployment failes, when deployed from zero. Keep an eye on it.
  # if it happens - activate direct upload of zip to blob-container as in commented resource_azure_function_deployzip.tf
  #zip_deploy_file  = "${path.module}/../../../../../app-006/python-consume/app.zip"


  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled          = false
    unauthenticated_client_action = "AllowAnonymous"
  }

  app_settings = {
      ServiceBusConnection    = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
  }

  site_config {
    application_stack {
      python_version = local.python_version
    }
  }

  # provisioner "local-exec" {
  #   command = "az functionapp deployment source config-zip -g ${azurerm_linux_function_app.az_func_app_consumer.resource_group_name} -n ${azurerm_linux_function_app.az_func_app_consumer.name} --src ${path.module}/../../../../../app-006/python-consume/app.zip"
  # }

}



resource "azurerm_linux_function_app" "az_func_app_publish" {
  name                       = "${local.az_function_name}-pub"
  location                   = local.location
  resource_group_name        = azurerm_resource_group.rg.name

  service_plan_id             = azurerm_service_plan.sp.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  https_only                 = true
  public_network_access_enabled  = true

  #zip_deploy_file  = "${path.module}/../../../../../app-006/python-publish/app.zip"


  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled          = false
    unauthenticated_client_action = "AllowAnonymous"
  }

  app_settings = {
      ServiceBusConnection    = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
  }

  site_config {
    application_stack {
      python_version = local.python_version
    }
  }

  # provisioner "local-exec" {
  #   command = "az functionapp deployment source config-zip -g ${azurerm_linux_function_app.az_func_app_consumer.resource_group_name} -n ${azurerm_linux_function_app.az_func_app_consumer.name} --src ${path.module}/../../../../../app-006/python-publish/app.zip"
  # }

}