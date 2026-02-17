output "vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "firewall_subnet_id" {
  value = azurerm_subnet.firewall.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}

output "resource_group_name" {
  value = azurerm_resource_group.hub.name
}

output "firewall_private_ip" {
  value = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
}

output "aks_private_dns_zone_name" {
  value = azurerm_private_dns_zone.aks_private_dns.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
