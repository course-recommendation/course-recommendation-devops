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
