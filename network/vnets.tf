// VIRTUAL NETWORK
resource "azurerm_virtual_network" "vnet" {
  for_each                = var.virtual_networks
  name                    = each.key
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  address_space           = each.value.address_space
  dns_servers             = each.value.dns_servers
  flow_timeout_in_minutes = each.value.flow_timeout_in_minutes

  tags = var.tags
}

// VNET PEERING

resource "azurerm_virtual_network_peering" "aks_2_afw" {
  name                         = "Peer2Afw"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet["vnet-aks-prd"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnet["vnet-aks-afw"].id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "afw_2_aks" {
  name                         = "Peer2Aks"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet["vnet-aks-afw"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnet["vnet-aks-prd"].id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

// SUBNET
resource "azurerm_subnet" "subnet" {
  for_each                                       = var.subnets
  name                                           = each.key
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = each.value.virtual_network_name
  address_prefixes                               = each.value.address_prefixes
  service_endpoints                              = each.value.service_endpoints
  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.enforce_private_link_service_network_policies

  depends_on = [
    azurerm_virtual_network.vnet, azurerm_resource_group.rg
  ]
}

// ROUTE TABLE
resource "azurerm_route_table" "rtb" {
  for_each                      = var.subnets
  name                          = each.value.route_table_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  tags = var.tags

  depends_on = [
    azurerm_subnet.subnet, azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet_route_table_association" "rtb" {
  for_each       = var.subnets
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.rtb[each.key].id
}

// NETWORK SECURITY GROUP

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnets
  name                = each.value.network_security_group_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

