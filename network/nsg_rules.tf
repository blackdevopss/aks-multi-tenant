resource "azurerm_network_security_rule" "nsg" {
  for_each                     = var.network_security_group_rules
  name                         = each.key
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_ranges           = each.value.source_port_ranges
  destination_port_ranges      = each.destination_port_ranges
  source_address_prefix        = each.value.source_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
  resource_group_name          = azurerm_resource_group.rg.name
  network_security_group_name  = each.value.network_security_group_name
}

