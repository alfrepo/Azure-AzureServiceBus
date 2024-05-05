variable "location" {
  description = "The AZ region to deploy the resources into"
  type = string
}

variable "prefix" {
  description = "The resource prefix"
  type = string
}

variable "az_function_name" {
  description = "The function name"
  type = string
}

variable "resource_group_name" {
  description = "resource_group_name"
  type = string
}


variable "storage_account_access_key" {
  description = "storage_account_access_key"
  type = string
}


variable "storage_account_name" {
  description = "storage_account_name"
  type = string
}

variable "python_version" {
  description = "python_version"
  type = string
}


variable "Env_ServiceBusConnection" {
  description = "ServiceBusConnection"
  type = string
}

variable "Env_ServiceBusTopicName" {
  description = "AzServiceBusTopicName"
  type = string
}

variable "Env_ServiceBusSessionId" {
  description = "AzServiceBusSessionId"
  type = string
}

variable "Env_Subscription" {
  description = "AzServiceBusSubscription"
  type = string
}

variable "service_plan_id" {
  description = "service_plan_id"
  type = string
}




locals {

}
