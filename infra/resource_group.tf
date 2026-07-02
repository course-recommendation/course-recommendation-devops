resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.project_name}"
  location = "East Asia"
}

data "azurerm_resource_group" "rg_cicd" {
  name = "rg-${local.project_name}-cicd"
}