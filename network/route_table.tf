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

// ROUTES

resource "azurerm_route" "udr" {
  for_each               = var.subnets
  name                   = "udr-default-egress"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = each.value.route_table_name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.afw.ip_configuration.0.private_ip_address
}