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

resource "azurerm_log_analytics_workspace" "aks" {
  name                = "loga-aks-core"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"

  tags = var.tags
}

resource "azurerm_network_watcher_flow_log" "nsg" {
  for_each             = var.subnets
  network_watcher_name = azurerm_network_watcher.netw.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = azurerm_network_security_group.nsg[each.key].name

  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = azurerm_storage_account.st_aks.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.aks.workspace_id
    workspace_region      = var.location
    workspace_resource_id = azurerm_log_analytics_workspace.aks.id
    interval_in_minutes   = 10
  }
}