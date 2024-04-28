# create or UPDATE the zips with Azure functions
# which gonna be referenced from functions and deployed upon terraform deploy

data "archive_file" "function_pub_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../../../app-005/python-publish/"
  output_path = "${path.module}/../../../../../app-005/python-publish/app.zip"

  # unfortunately wildcards do not work here, without terraform functions
  excludes    = ["app.zip", "az_func_package-as-zip.sh", "az_func_deploy.sh"]

#  depends_on = [null_resource.pip]
}

data "archive_file" "function_con_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../../../app-005/python-consume/"
  output_path = "${path.module}/../../../../../app-005/python-consume/app.zip"

  # unfortunately wildcards do not work here, without terraform functions
  excludes    = ["app.zip", "az_func_package-as-zip.sh", "az_func_deploy.sh"]

#  depends_on = [null_resource.pip]
}

# resource "null_resource" "pip" {
#   triggers = {
#     requirements_md5 = "${filemd5("${path.module}/../../../../../app/python/requirements.txt")}"
#   }
#   provisioner "local-exec" {    
#     command = "pip install --target='.python_packages/lib/site-packages' -r requirements.txt"
#     working_dir = "../${path.module}/blob_storage_trigger"
#   }
# }

# #storage container
# resource "azurerm_storage_container" "func_deploy_container" {
#   name                 = "${local.az_function_name}deploy"
#   storage_account_name = azurerm_storage_account.storage_account.name
#   container_access_type = "private" # Adjust access level as needed
# }

# #Uploading to the blob container
# resource "azurerm_storage_blob" "storage_blob_function" {
#   name                   = "app.zip"
#   storage_account_name   = azurerm_storage_account.storage_account.name
#   storage_container_name = azurerm_storage_container.func_deploy_container.name
#   type                   = "Block"
#   source                 = "${path.module}/../../../../../app/app.zip"
# }

# # unfortunately this presigned URL is required, 
# # so that the azurerm_linux_function_app
# # is able to access the app.zip
# # should find a better way to do it or restrict the access to the function only
# # refer to it via WEBSITE_RUN_FROM_PACKAGE
# data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
#   connection_string = azurerm_storage_account.storage_account.primary_connection_string
#   container_name    = azurerm_storage_container.func_deploy_container.name


#   start = local.startblob
#   expiry = local.expiryblob


#   permissions {
#     read   = true
#     add    = false
#     create = false
#     write  = false
#     delete = false
#     list   = false
#   }
# }
