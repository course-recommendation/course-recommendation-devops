resource "azurerm_static_web_app" "stapp" {
  name                = "stapp-${local.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_tier            = "Free"
  lifecycle {
    ignore_changes = [
      repository_branch,
      repository_url,
      sku_tier,
      sku_size
    ]
  }
}

resource "azurerm_static_web_app_custom_domain" "example" {
  static_web_app_id = azurerm_static_web_app.stapp.id
  domain_name       = "${azurerm_dns_cname_record.stapp_cname.name}.${azurerm_dns_zone.dns_zone.name}"
  validation_type   = "cname-delegation"
}
