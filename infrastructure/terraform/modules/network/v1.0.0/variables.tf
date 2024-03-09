variable "location" {
  description = "The AZ region to deploy the resources into"
  type = string
}

variable "prefix" {
  description = "The resource prefix"
  type = string
}

locals {
  resource_group_name = "${var.prefix}-azurerm_resource_group"

  vnet_name = "${var.prefix}-vnet"
  address_space         = "10.0.0.0/8" #The address space for the virtual network
  address_space_public  = "10.1.2.0/24"
  address_space_private = "10.0.1.0/24"
}
