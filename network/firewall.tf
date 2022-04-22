// FIREWALL PUBLIC IP
resource "azurerm_public_ip" "afw" {
  name                = var.firewall_public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

// FIREWALL SUBNET
resource "azurerm_subnet" "afw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = "vnet-aks-afw"
  address_prefixes     = var.firewall_subnet_address_prefix

  depends_on = [
    azurerm_virtual_network.vnet, azurerm_resource_group.rg
  ]
}

// FIREWALL
resource "azurerm_firewall" "afw" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.afwp.id
  threat_intel_mode   = var.firewall_threat_intel_mode
  zones               = var.firewall_zones

  ip_configuration {
    name                 = "pipcfg-aks-afw"
    subnet_id            = azurerm_subnet.afw_subnet.id
    public_ip_address_id = azurerm_public_ip.afw.id
  }

  tags = var.tags
}

// FIREWALL POLICY
resource "azurerm_firewall_policy" "afwp" {
  name                = var.firewall_policy_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  tags = var.tags
}


resource "azurerm_firewall_network_rule_collection" "afw_rc" {
  for_each            = var.afw_network_rules
  name                = each.key
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = each.value.priority
  action              = each.value.action

  rule {
    name = each.rule.value.name

    source_addresses = each.rule.value.source_addresses

    destination_ports = each.rule.value.destination_ports

    destination_addresses = each.rule.value.destination_address

    protocols = each.rule.value.protocols
  }
}
