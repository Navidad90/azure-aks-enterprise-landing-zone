variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "firewall_private_ip" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}
