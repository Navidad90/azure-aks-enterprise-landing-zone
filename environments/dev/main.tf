module "hub_network" {
  source = "../../modules/hub-network"

  location            = var.location
  resource_group_name = "rg-weu-aks-ent-hub"
  vnet_name           = "vnet-weu-aks-ent-hub"
  address_space       = ["10.0.0.0/16"]
}

module "spoke_network" {
  source = "../../modules/spoke-network"

  location            = var.location
  resource_group_name = "rg-weu-aks-ent-spoke"
  vnet_name           = "vnet-weu-aks-ent-spoke"
  address_space       = ["10.1.0.0/16"]

  firewall_private_ip        = module.hub_network.firewall_private_ip
  log_analytics_workspace_id = module.hub_network.log_analytics_workspace_id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = module.hub_network.resource_group_name
  virtual_network_name      = "vnet-weu-aks-ent-hub"
  remote_virtual_network_id = module.spoke_network.vnet_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = module.spoke_network.resource_group_name
  virtual_network_name      = "vnet-weu-aks-ent-spoke"
  remote_virtual_network_id = module.hub_network.vnet_id
  allow_forwarded_traffic   = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke_link" {
  name                  = "spoke-dns-link"
  resource_group_name   = module.hub_network.resource_group_name
  private_dns_zone_name = module.hub_network.aks_private_dns_zone_name
  virtual_network_id    = module.spoke_network.vnet_id
}
