resource "azurerm_role_assignment" "acr_pull_id" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
  principal_id         = azurerm_user_assigned_identity.id.principal_id
}

resource "azurerm_role_assignment" "key_vault_id" {
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.kv.id
  principal_id         = azurerm_user_assigned_identity.id.principal_id
}
