

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group_name}"
  location = var.location
}



# Create the virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  address_space       = ["${local.address_space}"]
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "net_public" {
  name                  = "${var.prefix}-net_public"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = ["${local.address_space_public}"]
}

resource "azurerm_subnet" "net_private" {
  name                  = "${var.prefix}-net_private"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = ["${local.address_space_private}"]
}
