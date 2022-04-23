// RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "netw" {
  name     = "NetworkWatcherRG"
  location = var.location

  tags = var.tags
}

// NETWORK WATCHER
resource "azurerm_network_watcher" "netw" {
  name                = "netwatcher_${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.netw.name
}

// STORAGE ACCOUNT FOR DIAGNOSTICS
resource "azurerm_storage_account" "st_aks" {
  name                = "staksdiaglogging"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  tags = var.tags
}

// LOG ANALYTICS WORKSPACE
resource "azurerm_log_analytics_workspace" "aks" {
  name                = "loga-aks-core"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"

  tags = var.tags
}

// NETWORK SECURITY GROUP RULE
resource "azurerm_network_security_rule" "nsg" {
  for_each                    = var.network_security_group_rules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_ranges     = each.value.destination_port_ranges
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = each.value.network_security_group_name

  depends_on = [
    azurerm_virtual_network.vnet, azurerm_subnet.subnet
  ]
}