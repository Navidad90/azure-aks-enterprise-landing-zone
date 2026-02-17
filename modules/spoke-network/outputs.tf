output "vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "aks_nodes_subnet_id" {
  value = azurerm_subnet.aks_nodes.id
}

output "resource_group_name" {
  value = azurerm_resource_group.spoke.name
}
