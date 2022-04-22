// RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

// NETWORK WATCHER
resource "azurerm_network_watcher" "netw" {
  name                = "netw-watcher-prd"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
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