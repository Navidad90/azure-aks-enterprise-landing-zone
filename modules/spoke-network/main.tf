resource "azurerm_resource_group" "spoke" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "spoke" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = var.address_space
}

# AKS Node Subnet
resource "azurerm_subnet" "aks_nodes" {
  name                 = "snet-aks-nodes"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Ingress Subnet
resource "azurerm_subnet" "ingress" {
  name                 = "snet-aks-ingress"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.2.0/24"]
}

# Private Endpoint Subnet
resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.3.0/24"]
}

# AKS API Server Subnet (Private Cluster)
resource "azurerm_subnet" "api_server" {
  name                 = "snet-aks-api"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.4.0/28"]
}

resource "azurerm_route" "default_route" {
  name                   = "default-to-firewall"
  resource_group_name    = azurerm_resource_group.spoke.name
  route_table_name       = azurerm_route_table.spoke_rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "aks_nodes_assoc" {
  subnet_id      = azurerm_subnet.aks_nodes.id
  route_table_id = azurerm_route_table.spoke_rt.id
}

resource "azurerm_route_table" "spoke_rt" {
  name                = "rt-weu-aks-ent-spoke"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
}

resource "azurerm_network_security_group" "aks_nsg" {
  name                = "nsg-weu-aks-ent-nodes"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
}

resource "azurerm_subnet_network_security_group_association" "aks_assoc" {
  subnet_id                 = azurerm_subnet.aks_nodes.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  name                        = "Allow-VNet-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.spoke.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-weu-aks-ent"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  dns_prefix          = "aksent"

  default_node_pool {
    name           = "system"
    vm_size        = "Standard_DS2_v2"
    node_count     = 1
    vnet_subnet_id = azurerm_subnet.aks_nodes.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  private_cluster_enabled = true

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }
}


