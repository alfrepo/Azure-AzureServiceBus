# API Management Service
resource "azurerm_api_management" "app" {
  name                = "${local.prefix}-example-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}

resource "azurerm_api_management_named_value" "example" {
  name                = "example-apimg"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  display_name        = "ExampleProperty"
  value               = "Example Value"
}


# correct is :
#https://alfdevapi3-example-apim.azure-api.net/alfdevapi3alfdevfunction-func/http_trigger
# question: how to decouple frontend-name from backend-name?

resource "azurerm_api_management_api" "mapi" {
  name                = "${local.prefix}-example-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  revision            = "1"
  display_name        = "Example API"
  #path                = azurerm_linux_function_app.az_func_app.name #TODO use the func ref
  path                = "hohosomemypathalf"
  protocols           = ["https"]

#   # works with whole swagger
#   import {
#     content_format = "swagger-link-json"
#     content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
#   }
}

resource "azurerm_api_management_api_operation" "example" {
  operation_id        = "user-get"
  api_name            = azurerm_api_management_api.mapi.name
  api_management_name = azurerm_api_management_api.mapi.api_management_name
  resource_group_name = azurerm_api_management_api.mapi.resource_group_name
  display_name        = "${local.prefix} Get User Operation"
  method              = "GET"
  url_template        = "/http_trigger"
  description         = "This gonna trigger my azure function."

  response {
    status_code = 200
  }
}




# how to handle 400 error
# https://github.com/hashicorp/terraform-provider-azurerm/issues/23130



resource "azurerm_api_management_backend" "backend_1" {
  name                = "${local.prefix}-ma-backend"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name

  protocol = "http"
  url      = "https://${azurerm_linux_function_app.az_func_app.name}.azurewebsites.net"

  credentials {
    header = {
      # Syntax refs https://github.com/hashicorp/terraform-provider-azurerm/issues/14575#issuecomment-1662020472
      # This value should match the value of azurerm_api_management_named_value.api_gateway__az_func_app_account_key.name
      "x-functions-key" = "{{${azurerm_linux_function_app.az_func_app.name}-key}}"
    }
  }


  # Note to me:
  # it might help against "unexpected status 400 with error"
  # to MANUALLY provision an API on APIM for the deployed Azure function
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_api_management.app,
    azurerm_linux_function_app.az_func_app,
    # It uses a reference syntax above, so this value must exist first, or validation can fail
    # "Backend: "api-host-function-app-backend"): unexpected status 400 with error: ValidationError: One or more fields contain incorrect values"
    azurerm_api_management_named_value.example
    #  azurerm_api_management_named_value.api_gateway__az_func_app_account_key
  ]
}



# Adds a policy that routes REST calls to the function app.
resource "azurerm_api_management_api_policy" "api" {
  api_name            = azurerm_api_management_api.mapi.name
  api_management_name = azurerm_api_management.app.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_api_management_backend.backend_1,
    azurerm_api_management_api.mapi
  ]

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service id="apim-generated-policy" backend-id="${azurerm_linux_function_app.az_func_app.name}" />
        <cors allow-credentials="false">
            <allowed-origins>
                <origin>*</origin>
            </allowed-origins>
            <allowed-methods>
                <method>GET</method>
                <method>POST</method>
            </allowed-methods>
        </cors>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}