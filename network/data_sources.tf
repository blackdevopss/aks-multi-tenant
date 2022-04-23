// GET THE FIREWALL PRIVATE IP ADDRESS
data "azurerm_firewall" "afw" {
  name                = "afw-shared"
  resource_group_name = "rg-aks-network"

  depends_on = [azurerm_firewall.afw]
}

output "firewall_private_ip" {
  value = data.azurerm_firewall.afw.ip_configuration.0.private_ip_address
}

