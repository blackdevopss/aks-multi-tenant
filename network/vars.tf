variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "nat_gateway_name" {
  type = string
}

variable "virtual_networks" {
  type = map(object({
    address_space           = list(string)
    dns_servers             = list(string)
    flow_timeout_in_minutes = number
  }))
}

variable "subnets" {
  type = map(object({
    virtual_network_name                           = string
    address_prefixes                               = list(string)
    service_endpoints                              = list(string)
    enforce_private_link_endpoint_network_policies = bool
    enforce_private_link_service_network_policies  = bool
    network_security_group_name                    = string
    route_table_name                               = string
  }))
}

variable "firewall_subnet_address_prefix" {
  type = list(string)

}

variable "network_security_group_rules" {
  type = map(object({
    priority                    = string
    direction                   = string
    access                      = string
    protocol                    = string
    source_port_range           = string
    destination_port_ranges     = list(string)
    source_address_prefix       = string
    destination_address_prefix  = string
    network_security_group_name = string
  }))

}

variable "firewall_name" {
  type = string
}

variable "firewall_sku_name" {
  type = string
}

variable "firewall_sku_tier" {
  type = string
}

variable "firewall_threat_intel_mode" {
  type = string
}

variable "firewall_zones" {
  type = list(string)
}

variable "firewall_public_ip_name" {
  type = string
}

variable "firewall_policy_name" {
  type = string
}


variable "firewall_application_rule_collection" {
  type = map(object({
    priority = number
    application_rule_collection = object({
      name                  = string
      priority              = number
      action                = string
      source_addresses      = list(string)
      destination_fqdns     = list(string)
      destination_fqdn_tags = list(string)
      rule = object({
        name = string
        protocols = object({
          type = string
          port = number
        })
      })
    })
  }))
}

variable "firewall_network_rule_collection" {
  type = map(object({
    priority = number
    network_rule_collection = object({
      name     = string
      priority = number
      action   = string
      rule = object({
        name                = string
        protocols           = list(string)
        source_addresses    = list(string)
        destination_address = list(string)
        destination_ports   = list(string)
      })
    })
  }))
}
