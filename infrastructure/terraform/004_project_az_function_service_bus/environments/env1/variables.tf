
# needs to be a var to reference from local block
variable "prefix" {
  description = "The resource prefix"
  type = string
  default = "alfdevapi4"
}

# needs to be a var to reference from local block
variable "environment" {
  description = "The environment"
  type = string

  # refers to folder-structure
  default = "env1" 
}


locals {
  location = "Switzerland North"
  location2 = "switzerlandnorth"

  environment_path = "environments/${var.environment}/"
  resourcegroup = "${var.prefix}-my-azfunc-rg"
  storage_account_az_func = "${var.prefix}storaccazfunc"
  az_function_name = "${var.prefix}alfdevfunction-func"
  python_version = "3.10"

  # make also adressable via "var."
  prefix = "${var.prefix}"
  environment = "${var.environment}"


  # ugly, fixed date
  startblob = "2024-01-01T00:00:00Z"
  expiryblob = "2025-01-01T00:00:00Z" 
}
