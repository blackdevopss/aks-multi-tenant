// VIRTUAL NETWORKS

resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.aks_vnet_address_space
  dns_servers         = var.dns_servers

  tags = var.tags
}

resource "azurerm_virtual_network" "afw_vnet" {
  name                = var.afw_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.afw_vnet_address_space
  dns_servers         = var.dns_servers

  tags = var.tags
}

// VNET SUBNETS

resource "azurerm_subnet" "aks_nodes" {
  name                                           = var.prod_cluster_nodes_vnet_subnet
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.aks_vnet.name
  address_prefixes                               = var.prod_cluster_vnet_address_prefixes
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true

}

resource "azurerm_subnet" "aks_argocd" {
  name                                           = var.mgmt_cluster_node_vnet_subnet
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.aks_vnet.name
  address_prefixes                               = var.argocd_subnet_address_prefixes
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true

}

resource "azurerm_subnet" "aks_agic" {
  name                                           = var.app_gateway_ingress_vnet_subnet
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.aks_vnet.name
  address_prefixes                               = var.agic_subnet_address_prefixes
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true

}




