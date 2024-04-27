

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


resource "azurerm_linux_function_app" "az_func_app_publisher" {
  name                       = "${local.az_function_name}-pub"
  location                   = local.location
  resource_group_name        = azurerm_resource_group.rg.name

  service_plan_id             = azurerm_service_plan.sp.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  https_only                 = true
  public_network_access_enabled  = true

  #zip_deploy_file  = "${path.module}/../../../../../app-004/python-publish/app.zip"


  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip -g ${azurerm_linux_function_app.az_func_app_publisher.resource_group_name} -n ${azurerm_linux_function_app.az_func_app_publisher.name} --src ${path.module}/../../../../../app-004/python-publish/app.zip"
  }

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled          = false
    unauthenticated_client_action = "AllowAnonymous"
  }

  app_settings = {
      AzureWebJobsFeatureFlags = "EnableWorkerIndexing" # Here is the reason why you need this value: https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-python?pivots=python-mode-decorators#update-app-settings
      FUNCTIONS_WORKER_RUNTIME = "python"
      WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.storage_account.name}.blob.core.windows.net/${azurerm_storage_container.func_deploy_container.name}/${azurerm_storage_blob.storage_blob_function.name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas}",
      ServiceBusConnection    = azurerm_servicebus_namespace_authorization_rule.sb-ar.primary_connection_string
  }

  site_config {
    application_stack {
      python_version = local.python_version
    }
  }
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

  #zip_deploy_file  = "${path.module}/../../../../../app-004/python-consume/app.zip"

  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip -g ${azurerm_linux_function_app.az_func_app_consumer.resource_group_name} -n ${azurerm_linux_function_app.az_func_app_consumer.name} --src ${path.module}/../../../../../app-004/python-consume/app.zip"
  }

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
}