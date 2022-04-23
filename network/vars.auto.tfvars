resource_group_name = "rg-aks-network"
location            = "centralus"

//FIREWALL
firewall_name              = "afw-aks-shared"
firewall_sku_name          = "AZFW_VNet"
firewall_sku_tier          = "Premium"
firewall_threat_intel_mode = "Alert"
firewall_zones             = ["1"]
firewall_policy_name       = "afw-policy-main"
firewall_public_ip_name    = "pip-aks-afw"

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
    "Microsoft.AzureActiveDirectory", "Microsoft.Web"]
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
    "Microsoft.AzureActiveDirectory", "Microsoft.Web"]
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
    "Microsoft.AzureActiveDirectory", "Microsoft.Web"]
    virtual_network_name        = "vnet-aks-prd"
    network_security_group_name = "nsg-agw-snet"
    route_table_name            = "rtb-agw-snet"
  }
}

// FIREWALL RULES
firewall_application_rule_collection = {

  "RCG-AKS-Application" = {

    application_rule_collection = {
      action                = "Allow"
      destination_fqdns     = ["*.microsoft.com"]
      destination_fqdn_tags = ["AzureKubernetesService"]
      name                  = "RC-AKS-Application"
      priority              = 500

      rule = {
        name = "AzureKubernetesService"
        protocols = {
          port = 443
          type = "Https"
        }
      }

      source_addresses = ["10.0.8.0/21", "10.0.2.0/23"]
    }
    priority = 500
  }
}

firewall_network_rule_collection = {

  "RCG-AKS-Network" = {

    network_rule_collection = {
      action   = "Allow"
      name     = "RC-AKS-Network"
      priority = 400

      rule = {
        destination_address = ["*"]
        destination_ports   = ["1194", "9000"]
        name                = "AzureKubernetesService"
        protocols           = ["UDP"]
        source_addresses    = ["10.0.8.0/21", "10.0.2.0/23"]
      }
    }
    priority = 400
  }
}

// NETWORK SECURITY GROUP RULES
network_security_group_rules = {

  "AllowGatewayManager" = {
    access                      = "Allow"
    destination_address_prefix  = "*"
    destination_port_ranges     = ["65200-65535"]
    direction                   = "Inbound"
    network_security_group_name = "nsg-agw-snet"
    priority                    = "300"
    protocol                    = "Tcp"
    source_address_prefix       = "GatewayManager"
    source_port_range           = "*"
  }
}

tags = {
  "provisioner" = "terraform"
  "category"    = "network"
  "environment" = "prd"
}