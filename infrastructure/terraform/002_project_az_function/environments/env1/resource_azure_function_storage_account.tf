

# Random String Resource for Storage Account Name
resource "random_string" "storage_account_name" {
  length = 20
  special = false
}


# Azure Storage Account with Random Name
resource "azurerm_storage_account" "storage_account" {
  name                = local.storage_account_az_func
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  account_tier        = "Standard"
  account_replication_type = "LRS"
}