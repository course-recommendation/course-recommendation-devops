resource "azurerm_dns_zone" "dns_zone" {
  name                = "courserecom.site"
  resource_group_name = azurerm_resource_group.rg.name
}
