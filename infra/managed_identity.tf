resource "azurerm_user_assigned_identity" "id" {
  name                = "id-${local.project_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
