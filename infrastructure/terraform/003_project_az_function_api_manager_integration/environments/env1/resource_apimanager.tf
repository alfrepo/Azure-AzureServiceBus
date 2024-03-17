# # API Management Service
# resource "azurerm_api_management" "apim_service" {
#   name                = "my-apim-service"
#   location            = azurerm_resource_group.apim_rg.location
#   publisher_name      = "my-publisher"
#   publisher_email     = "youremail@example.com"
#   sku {
#     tier  = "Developer"
#     size  = "1"
#   }
#   # ... other configuration options (see documentation)
# }

