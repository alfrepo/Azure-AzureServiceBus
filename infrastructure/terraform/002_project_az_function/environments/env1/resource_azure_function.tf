

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

resource "azurerm_application_insights" "az_func_insights" {
  name                = "${var.prefix}-appinsights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"
}

resource "azurerm_linux_function_app" "az_func_app" {
  name                       = local.az_function_name
  location                   = local.location
  resource_group_name        = azurerm_resource_group.rg.name

  service_plan_id             = azurerm_service_plan.sp.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  https_only                 = true
  public_network_access_enabled  = true

  app_settings = {
    #WEBSITE_RUN_FROM_PACKAGE = azurerm_storage_blob.storage_blob_function.url,

    # let the function run from app.zip
    # https://www.maxivanov.io/publish-azure-functions-code-with-terraform/
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.storage_account.name}.blob.core.windows.net/${azurerm_storage_container.func_deploy_container.name}/${azurerm_storage_blob.storage_blob_function.name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas}",

    # WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    # WEBSITES_MOUNT_ENABLED = 1
    # FUNCTIONS_WORKER_RUNTIME = "python"
    # AzureWebJobsStorage = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.storage_account.name};AccountKey=${azurerm_storage_account.storage_account.primary_access_key}"
  }

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
}


