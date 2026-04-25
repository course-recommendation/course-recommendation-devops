resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.project_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_sql" {
  name                 = "subnet-sql"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet_ca" {
  name                 = "subnet-ca"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.16.0/20"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_private_dns_zone" "sql_private_dns_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "my_terraform_vnet_link" {
  name                  = "vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "pe_sql" {
  name                = "pe-sql-${local.project_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet_sql.id

  private_service_connection {
    name                           = "pe-sql-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql_server.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_private_dns_zone.id]
  }
}
