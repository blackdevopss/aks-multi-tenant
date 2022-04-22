output "subnets" {
  value = tomap({
    for s, subnet in azurerm_subnet.subnet : s => {
      id = subnet.id
    }
  })
}

output "vnets" {
  value = tomap({
    for v, vnet in azurerm_virtual_network.vnet : v => {
      id = vnet.id
    }
  })
}

output "vnet_names" {
  value = tomap({
    for nm, vnet in azurerm_virtual_network.vnet : nm => {
      name = vnet.name
    }
  })
}

output "nsgs" {
  value = tomap({
    for n, nsg in azurerm_network_security_group.nsg : n => {
      id = nsg.id
    }
  })
}

output "rtb" {
  value = tomap({
    for rt, rtb in azurerm_route_table.rtb : rt => {
      id = rtb.id
    }
  })
}
