  data "azurerm_dns_zone" "dns_zone" {
  name                = "course-pilot.site"
  resource_group_name = data.azurerm_resource_group.rg_cicd.name
}
