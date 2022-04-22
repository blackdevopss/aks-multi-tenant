// NODE POOL SUBNET NSG
resource "azurerm_network_security_group" "aks" {
  name                = "nsg-akspool-snet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tag = var.tags
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks_nodes.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

// APP GATEWAY SUBNET NSG
resource "azurerm_network_security_group" "aks_agic" {
  name                = "nsg-agic-snet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tag = var.tags
}

resource "azurerm_subnet_network_security_group_association" "aks_agic" {
  subnet_id                 = azurerm_subnet.aks_agic.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

// ARGOCD SUBNET NSG
resource "azurerm_network_security_group" "argocd" {
  name                = "nsg-argocd-snet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tag = var.tags
}

resource "azurerm_subnet_network_security_group_association" "argocd" {
  subnet_id                 = azurerm_subnet.aks_argocd.id
  network_security_group_id = azurerm_network_security_group.argocd.id
}

// APP GATEWAY NSG RULES
resource "azurerm_network_security_rule" "agw" {
  for_each                     = var.agw_subnet_nsg_rules
  name                         = each.key
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = "Tcp"
  source_port_ranges           = each.value.source_port_ranges
  destination_port_ranges      = each.value.destination_port_ranges
  source_address_prefix        = each.value.source_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
  resource_group_name          = azurerm_resource_group.rg.name
  network_security_group_name  = each.value.network_security_group_name
}