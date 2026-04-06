resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                   = "mysqlserver-${local.project_name}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = "Indonesia Central"
  administrator_login    = "username"
  administrator_password = var.mysql_admin_password
  sku_name               = "B_Standard_B1ms"
  version                = "5.7"
}

resource "azurerm_mysql_flexible_database" "mysql_db" {
  name                = "mysql-${local.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysql_firewall_rule" {
  name                = "allow_all"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
