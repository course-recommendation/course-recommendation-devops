resource "azurerm_key_vault" "kv" {
  name                       = "kv-${local.project_name}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  rbac_authorization_enabled = true
}

resource "azurerm_key_vault_secret" "mysql-root-password" {
  name         = "mysql-root-password"
  value        = azurerm_mysql_flexible_server.mysql_server.administrator_password
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "openai-api-key" {
  name         = "openai-api-key"
  value        = var.openai_api_key
  key_vault_id = azurerm_key_vault.kv.id
}
