// FIREWALL PUBLIC IP
resource "azurerm_public_ip" "afw" {
  name                = var.firewall_public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

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

// FIREWALL APPLICATION RULE GROUP COLLECTION
resource "azurerm_firewall_policy_rule_collection_group" "application" {
  for_each           = var.firewall_application_rule_collection
  name               = each.key
  firewall_policy_id = azurerm_firewall_policy.afwp.id
  priority           = 500

  application_rule_collection {
    name     = each.value.application_rule_collection.name
    priority = 500
    action   = each.value.application_rule_collection.action
    rule {
      name = each.value.application_rule_collection.rule.name
      protocols {
        type = each.value.application_rule_collection.rule.protocols.type
        port = each.value.application_rule_collection.rule.protocols.port
      }
      source_addresses  = each.value.application_rule_collection.source_addresses
      destination_fqdns = each.value.application_rule_collection.destination_fqdns
    }
  }
}

// NETWORK RULE GROUP COLLECTION
resource "azurerm_firewall_policy_rule_collection_group" "rcg" {
  for_each           = var.firewall_network_rule_collection
  name               = each.key
  firewall_policy_id = azurerm_firewall_policy.afwp.id
  priority           = 400

  network_rule_collection {
    name     = each.value.network_rule_collection.name
    priority = 400
    action   = each.value.network_rule_collection.action
    rule {
      name                  = each.value.network_rule_collection.rule.name
      protocols             = each.value.network_rule_collection.rule.protocols
      source_addresses      = each.value.network_rule_collection.rule.source_addresses
      destination_addresses = each.value.network_rule_collection.rule.destination_addresses
      destination_ports     = each.value.network_rule_collection.rule.destination_ports
    }
  }
}

// DNAT RULE COLLECTION
/*
resource "azurerm_firewall_policy_rule_collection_group" "rcg" {
  for_each           = var.firewall_rules_collection_groups
  name               = each.key
  firewall_policy_id = azurerm_firewall_policy.afwp.id
  priority           = 200


  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "192.168.1.1"
      destination_ports   = ["80", "1000-2000"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
  }
 
}
 */