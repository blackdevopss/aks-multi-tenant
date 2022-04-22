variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
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