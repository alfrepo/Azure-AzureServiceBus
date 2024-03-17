
# needs to be a var to reference from local block
variable "prefix" {
  description = "The resource prefix"
  type = string
  default = "alfdevpr1"
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
  storage_account_az_func = "${var.prefix}storaccazfunc1"
  az_function_name = "${var.prefix}alfdevfunction2-func"



  # make also adressable via "var."
  prefix = "${var.prefix}"
  environment = "${var.environment}"

  # # Get yesterday's date
  # yesterday = sub(timestamp() , duration(1 * "d"))

  # # Format yesterday's date in RFC 3339 format with UTC timezone
  # blob_start = format("%sZ", formatdate(yesterday, "RFC3339"))

  # # Get yesterday's date
  # nextyear = add(timestamp(), duration(366 * "d"))

  # # Format yesterday's date in RFC 3339 format with UTC timezone
  # blob_expire = format("%sZ", formatdate(nextyear, "RFC3339"))
}
