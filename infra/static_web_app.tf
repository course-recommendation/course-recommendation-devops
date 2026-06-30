resource "azurerm_static_web_app" "stapp" {
  name                = "stapp-${local.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_tier            = "Standard"
  lifecycle {
    ignore_changes = [
      repository_branch,
      repository_url,
    ]
  }
}

resource "azurerm_dns_cname_record" "stapp_cname" {
  name                = "www"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_static_web_app.stapp.default_host_name
}

resource "azurerm_static_web_app_custom_domain" "stapp_custom_domain" {
  static_web_app_id = azurerm_static_web_app.stapp.id
  domain_name       = "${azurerm_dns_cname_record.stapp_cname.name}.${azurerm_dns_zone.dns_zone.name}"
  validation_type   = "cname-delegation"
}

resource "azurerm_dns_cname_record" "stapp_cname_test1" {
  name                = "test1"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_static_web_app.stapp.default_host_name
}

resource "azurerm_static_web_app_custom_domain" "stapp_custom_domain_test1" {
  static_web_app_id = azurerm_static_web_app.stapp.id
  domain_name       = "${azurerm_dns_cname_record.stapp_cname_test1.name}.${azurerm_dns_zone.dns_zone.name}"
  validation_type   = "cname-delegation"
}

resource "azurerm_dns_cname_record" "stapp_cname_test2" {
  name                = "test2"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_static_web_app.stapp.default_host_name
}

resource "azurerm_static_web_app_custom_domain" "stapp_custom_domain_test2" {
  static_web_app_id = azurerm_static_web_app.stapp.id
  domain_name       = "${azurerm_dns_cname_record.stapp_cname_test2.name}.${azurerm_dns_zone.dns_zone.name}"
  validation_type   = "cname-delegation"
}

resource "azurerm_dns_cname_record" "stapp_cname_test3" {
  name                = "test3"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_static_web_app.stapp.default_host_name
}

resource "azurerm_static_web_app_custom_domain" "stapp_custom_domain_test3" {
  static_web_app_id = azurerm_static_web_app.stapp.id
  domain_name       = "${azurerm_dns_cname_record.stapp_cname_test3.name}.${azurerm_dns_zone.dns_zone.name}"
  validation_type   = "cname-delegation"
}

resource "azurerm_dns_cname_record" "stapp_cname_test4" {
  name                = "test4"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_static_web_app.stapp.default_host_name
}

resource "azurerm_static_web_app_custom_domain" "stapp_custom_domain_test4" {
  static_web_app_id = azurerm_static_web_app.stapp.id
  domain_name       = "${azurerm_dns_cname_record.stapp_cname_test4.name}.${azurerm_dns_zone.dns_zone.name}"
  validation_type   = "cname-delegation"
}