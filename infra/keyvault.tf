# resource "azurerm_key_vault" "kv" {
#   name                       = var.environment == "prod" ? "keyvault-${local.project_name}-${var.environment}" : "kv-${local.project_name}-${var.environment}"
#   location                   = azurerm_resource_group.rg.location
#   resource_group_name        = azurerm_resource_group.rg.name
#   tenant_id                  = data.azurerm_client_config.current.tenant_id
#   sku_name                   = "standard"
#   purge_protection_enabled   = true
#   rbac_authorization_enabled = true
# }

# resource "azurerm_key_vault_secret" "jwt-secret-key" {
#   name         = "jwt-secret-key"
#   value        = var.jwt_secret_key
#   key_vault_id = azurerm_key_vault.kv.id
# }

# resource "azurerm_key_vault_secret" "communication-service-connection-string" {
#   name         = "communication-service-connection-string"
#   value        = azurerm_communication_service.acs.primary_connection_string
#   key_vault_id = azurerm_key_vault.kv.id
# }

# resource "azurerm_key_vault_secret" "azure-openai-api-key" {
#   name         = "azure-openai-api-key"
#   value        = azurerm_cognitive_account.aif.primary_access_key
#   key_vault_id = azurerm_key_vault.kv.id
# }

# resource "azurerm_key_vault_secret" "database-url" {
#   name         = "database-url"
#   value        = "postgresql+asyncpg://${azurerm_postgresql_flexible_server.psqlserver.administrator_login}:${urlencode(azurerm_postgresql_flexible_server.psqlserver.administrator_password)}@${azurerm_postgresql_flexible_server.psqlserver.name}.postgres.database.azure.com:5432/${azurerm_postgresql_flexible_server_database.psql.name}"
#   key_vault_id = azurerm_key_vault.kv.id
# }

# resource "azurerm_key_vault_secret" "storage-account-connection-string" {
#   name         = "storage-account-connection-string"
#   value        = azurerm_storage_account.st.primary_connection_string
#   key_vault_id = azurerm_key_vault.kv.id
# }

# resource "azurerm_key_vault_secret" "azure-openai-api-key-fallback" {
#   name         = "azure-openai-api-key-fallback"
#   value        = azurerm_cognitive_account.aif_fallback.primary_access_key
#   key_vault_id = azurerm_key_vault.kv.id
# }
