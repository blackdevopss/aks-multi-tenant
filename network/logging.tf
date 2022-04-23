resource "azurerm_network_watcher_flow_log" "nsg" {
  for_each             = var.subnets
  network_watcher_name = azurerm_network_watcher.netw.name
  resource_group_name  = azurerm_resource_group.netw.name
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

  lifecycle {
    ignore_changes = [location]
  }
}

// VNET DIAGNOSTICS
resource "azurerm_monitor_diagnostic_setting" "vnet" {
  for_each           = var.virtual_networks
  name               = azurerm_virtual_network.vnet[each.key].name
  target_resource_id = azurerm_virtual_network.vnet[each.key].id
  storage_account_id = azurerm_storage_account.st_aks.id

  log {
    category = "VMProtectionAlerts"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}