# API Management Service
resource "azurerm_api_management" "app" {
  name                = "${local.prefix}-example-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}




resource "azurerm_api_management_api" "mapi" {
  name                = "${local.prefix}-example-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
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
  url_template        = "/users/"
  description         = "This gonna trigger my azure function."

  response {
    status_code = 200
  }
}

# resource "azurerm_api_management_api_operation_tag" "example" {
#   name             = "${local.prefix}-example-Tag"
#   api_operation_id = azurerm_api_management_api_operation.example.id
#   display_name     = "example-Tag"
# }


# # https://github.com/hashicorp/terraform-provider-azurerm/issues/5032

# # Adds the function app as a backend for the API.
# resource "azurerm_api_management_backend" "api" {
#   name                = azurerm_linux_function_app.az_func_app.name
#   description         = azurerm_linux_function_app.az_func_app.name
#   #resource_id         = "https://management.azure.com${azurerm_linux_function_app.az_func_app.id}"
#   resource_group_name = azurerm_resource_group.rg.name
#   api_management_name = azurerm_api_management.app.name
#   protocol            = "http"
#   url                 = "https://${azurerm_linux_function_app.az_func_app.default_hostname}/api"

#   credentials {
#     certificate = []
#     header      = {
#         "x-functions-key" = "{{${azurerm_linux_function_app.az_func_app.name}-key}}"
#       }
#     query       = {}
#   }
# }

# # Adds a policy that routes REST calls to the function app.
# resource "azurerm_api_management_api_policy" "api" {
#   api_name            = azurerm_api_management_api.mapi.name
#   api_management_name = azurerm_api_management_api.mapi.api_management_name
#   resource_group_name = azurerm_resource_group.rg.name

#   xml_content = <<XML
# <policies>
#     <inbound>
#         <base />
#         <set-backend-service id="apim-generated-policy" backend-id="${azurerm_linux_function_app.az_func_app.name}" />
#     </inbound>
#     <backend>
#         <base />
#     </backend>
#     <outbound>
#         <base />
#     </outbound>
#     <on-error>
#         <base />
#     </on-error>
# </policies>
# XML
# }