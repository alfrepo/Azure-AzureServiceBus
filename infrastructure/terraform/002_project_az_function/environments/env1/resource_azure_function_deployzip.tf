data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../../../app/python/"
  output_path = "${path.module}/../../../../../app/app.zip"
#  depends_on = [null_resource.pip]
}

# resource "null_resource" "pip" {
#   triggers = {
#     requirements_md5 = "${filemd5("../${path.module}/blob_storage_trigger/requirements.txt")}"
#   }
#   provisioner "local-exec" {    
#     command = "pip install --target='.python_packages/lib/site-packages' -r requirements.txt"
#     working_dir = "../${path.module}/blob_storage_trigger"
#   }
# }

#storage container
resource "azurerm_storage_container" "func_deploy_container" {
  name                 = "${local.az_function_name}deploy"
  storage_account_name = azurerm_storage_account.storage_account.name
  container_access_type = "private" # Adjust access level as needed
}

#Uploading to the blob container
resource "azurerm_storage_blob" "storage_blob_function" {
  name                   = "app.zip"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.func_deploy_container.name
  type                   = "Block"
  source                 = "${path.module}/../../../../../app/app.zip"
}
