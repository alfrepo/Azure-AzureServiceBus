# resource "azurerm_key_vault" "my_key_vault" {
#   name         = "${local.prefix}my-key-vault"
#   location     = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name =  "standard"
#   tenant_id =  data.azurerm_client_config.current.tenant_id

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     secret_permissions = [
#       "Set", "Get", "Delete", "Purge", "List",  ]
#   }
# }

# resource  "azurerm_key_vault_secret"  "primary_storage_key" {
#   name =  "primary-storage-key"
#   value =  azurerm_storage_account.storage_account.primary_access_key
#   key_vault_id =  azurerm_key_vault.my_key_vault.id
# }