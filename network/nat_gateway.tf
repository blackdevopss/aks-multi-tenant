resource "azurerm_public_ip_prefix" "nat" {
  name                = "pip-ngw-aks-prd"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 28
  zones               = ["1"]

  tags = var.tags
}

resource "azurerm_nat_gateway" "nat" {
  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  zones                   = ["1"]


  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat" {
  nat_gateway_id      = azurerm_nat_gateway.nat.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "nat" {
  for_each       = var.subnets
  subnet_id      = azurerm_subnet.subnet[each.key].id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

