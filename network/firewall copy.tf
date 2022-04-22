/*
// FIREWALL PUBLIC IP
resource "azurerm_public_ip" "afw" {
  name                = "pip-aks-afw"
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
  name                = "afw-aks-core"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.afwp.id
  threat_intel_mode   = "Alert"
  zones               = ["1", "2"]

  ip_configuration {
    name                 = "pipcfg-aks-afw"
    subnet_id            = azurerm_subnet.afw_subnet.id
    public_ip_address_id = azurerm_public_ip.afw.id
  }

  tags = var.tags
}

// FIREWALL POLICY
resource "azurerm_firewall_policy" "afwp" {
  name                = "afw-aks-policy-core"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  tags = var.tags
}

// FIREWALL RULE COLLECTION GROUP
resource "azurerm_firewall_policy_rule_collection_group" "rcg" {
  name               = "RCG-afw-aks-core"
  firewall_policy_id = azurerm_firewall_policy.afwp.id
  priority           = 500

  application_rule_collection {
    name     = "RC-Application"
    priority = 500
    action   = "Deny"

    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = [".microsoft.com"]
    }
  }

  network_rule_collection {
    name     = "RC-Network"
    priority = 400
    action   = "Deny"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.0.1"]
      destination_addresses = ["192.168.1.1", "192.168.1.2"]
      destination_ports     = ["80", "1000-2000"]
    }
  }

  nat_rule_collection {
    name     = "RC-DNat"
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