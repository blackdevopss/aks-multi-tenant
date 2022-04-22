variable "location" {
  type    = string
  default = "centralus"
}

variable "resource_group_name" {
  type    = string
  default = "rg-aks-network"
}

variable "aks_vnet_name" {
  type    = string
  default = "vnet-aks-prod"
}

variable "afw_vnet_name" {
  type    = string
  default = "vnet-afw-core"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "vnet_dns_servers" {
  type    = list(string)
  default = ["10.0.1.11", "10.0.1.12"]
}


variable "tags" {
  type = map(string)
  default = {
    "provisioner" = "terraform"
    "category"    = "network"
    "environment" = "dev"
  }
}

variable "agw_subnet_nsg_rules" {
  type = map(object({
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_ranges           = list(string)
    destination_port_ranges      = list(string)
    source_address_prefixes      = list(string)
    destination_address_prefixes = list(string)
    network_security_group_name  = string
  }))

  default = {
    "AllowGatewayManager" = {
      access                       = "Allow"
      destination_address_prefixes = ["*"]
      destination_port_ranges      = ["65200-65535"]
      direction                    = "Inbound"
      network_security_group_name  = "nsg-agic-snet"
      priority                     = 300
      protocol                     = "Tcp"
      source_address_prefix        = ["GatewayManager"]
      source_port_ranges           = ["*"]
    }
  }
}