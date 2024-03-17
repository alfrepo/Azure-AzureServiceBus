
# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.resourcegroup
  location = local.location2
}

