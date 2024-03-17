
# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-my-azfunc1-rg"
  location = local.location2
}

