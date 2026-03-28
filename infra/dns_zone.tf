resource "azurerm_dns_zone" "dns_zone" {
  name                = "courserecom.site"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_txt_record" "ca_txt" {
  name                = "asuid.api"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 3600
  record {
    value = azurerm_container_app.ca.custom_domain_verification_id
  }
}

resource "azurerm_dns_cname_record" "ca_cname" {
  name                = "api"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 3600
  record              = "${azurerm_container_app.ca.name}.${azurerm_container_app_environment.cae.default_domain}"
}

resource "azurerm_dns_cname_record" "stapp_cname" {
  name                = "www"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_static_web_app.stapp.default_host_name
}