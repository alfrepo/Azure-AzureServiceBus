



resource "azurerm_linux_function_app" "az_func_app" {
  name                       = "${var.az_function_name}"
  location                   = "${var.location}"
  resource_group_name        = "${var.resource_group_name}"

  service_plan_id             = "${var.service_plan_id}"
  storage_account_name        = "${var.storage_account_name}"
  storage_account_access_key  = "${var.storage_account_access_key}"
  https_only                  = true
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
      ServiceBusConnection    = "${var.Env_ServiceBusConnection}"
      Topic = "${var.Env_ServiceBusTopicName}"
      SessionId = "${var.Env_ServiceBusSessionId}"
      Subscription = "${var.Env_Subscription}"
  }

  site_config {
    application_stack {
      python_version = "${var.python_version}"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
    
    application_insights_key = azurerm_application_insights.app_insight.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.app_insight.connection_string

  }
}



# App Insight is created with Workspace Mode 
resource "azurerm_log_analytics_workspace" "law_fxapp" {
  name                = "${var.az_function_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "app_insight" {
  name                  = "${var.az_function_name}"
  resource_group_name   = "${var.resource_group_name}"
  location              = var.location
  workspace_id          = azurerm_log_analytics_workspace.law_fxapp.id
  application_type      = "web"
}

