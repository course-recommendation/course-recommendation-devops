resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.project_name}"
  location = "East Asia"
}
