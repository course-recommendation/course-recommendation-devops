# resource "azurerm_container_registry" "acr" {
#   name                = "acr${local.project_name}${var.environment}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "Basic"
# }
