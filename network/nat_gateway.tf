resource "azurerm_public_ip_prefix" "nat" {
  name                = "nat-gateway-publicIPPrefix"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 30
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat" {
  name                    = "nat-Gateway"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.example.name
  public_ip_address_ids   = [azurerm_public_ip.example.id]
  public_ip_prefix_ids    = [azurerm_public_ip_prefix.example.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_subnet_nat_gateway_association" "nat" {
  subnet_id      = azurerm_subnet.example.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}