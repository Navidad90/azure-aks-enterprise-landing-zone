variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Hub resource group name"
  type        = string
}

variable "vnet_name" {
  description = "Hub virtual network name"
  type        = string
}

variable "address_space" {
  description = "Hub VNet address space"
  type        = list(string)
}
