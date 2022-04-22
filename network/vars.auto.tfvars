resource_group_name = "rg-aks-network"
location            = "centralus"


// VIRTUAL NETWORKS
firewall_subnet_address_prefix = ["192.168.0.0/25"]
nat_gateway_name               = "ngw-aksvnet-prd"

virtual_networks = {

  "vnet-aks-prd" = {
    address_space           = ["10.0.0.0/19"]
    dns_servers             = ["168.63.129.16"]
    flow_timeout_in_minutes = 4
  }

  "vnet-aks-afw" = {
    address_space           = ["192.168.0.0/22"]
    dns_servers             = ["168.63.129.16"]
    flow_timeout_in_minutes = 4
  }
}

// VNET SUBNETS
subnets = {

  "snet-aks-nodes" = {
    address_prefixes                               = ["10.0.8.0/21"]
    enforce_private_link_endpoint_network_policies = true
    enforce_private_link_service_network_policies  = true
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.ContainerRegistry",
      "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.EventHub",
    "Microsoft.AzureActiveDirectory", "Microsoft.Web", "Microsoft.CognitiveServices"]
    virtual_network_name        = "vnet-aks-prd"
    network_security_group_name = "nsg-npool-snet"
    route_table_name            = "rtb-npool-snet"
  }

  "snet-aks-mgmt" = {
    address_prefixes                               = ["10.0.2.0/23"]
    enforce_private_link_endpoint_network_policies = true
    enforce_private_link_service_network_policies  = true
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.ContainerRegistry",
      "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.EventHub",
    "Microsoft.AzureActiveDirectory", "Microsoft.Web", "Microsoft.CognitiveServices"]
    virtual_network_name        = "vnet-aks-prd"
    network_security_group_name = "nsg-mgmt-snet"
    route_table_name            = "rtb-mgmt-snet"
  }

  "snet-aks-agw" = {
    address_prefixes                               = ["10.0.1.0/24"]
    enforce_private_link_endpoint_network_policies = true
    enforce_private_link_service_network_policies  = true
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.ContainerRegistry",
      "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.EventHub",
    "Microsoft.AzureActiveDirectory", "Microsoft.Web", "Microsoft.CognitiveServices"]
    virtual_network_name        = "vnet-aks-prd"
    network_security_group_name = "nsg-agw-snet"
    route_table_name            = "rtb-agw-snet"
  }
}

network_security_group_rules = {

  "AllowGatewayManager" = {
    access                       = "Allow"
    destination_address_prefixes = ["*"]
    destination_port_ranges      = ["65200-65535"]
    direction                    = "Inbound"
    network_security_group_name  = "nsg-agw-snet"
    priority                     = "300"
    protocol                     = "Tcp"
    source_address_prefix        = "GatewayManager"
    source_port_ranges           = ["*"]
  }
}

tags = {
  "provisioner" = "terraform"
  "category"    = "network"
  "environment" = "prd"
}