# resource "azurerm_container_app_environment" "cae" {
#   name                       = "cae-${local.project_name}-${var.environment}"
#   resource_group_name        = azurerm_resource_group.rg.name
#   location                   = azurerm_resource_group.rg.location
#   logs_destination           = "log-analytics"
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
# }

# resource "azurerm_container_app" "ca" {
#   name                         = "ca-${local.project_name}-${var.environment}"
#   container_app_environment_id = azurerm_container_app_environment.cae.id
#   resource_group_name          = azurerm_container_app_environment.cae.resource_group_name
#   revision_mode                = "Single"

#   registry {
#     server   = azurerm_container_registry.acr.login_server
#     identity = azurerm_user_assigned_identity.id.id
#   }

#   template {
#     container {
#       name   = "examplecontainerapp"
#       image  = "mcr.microsoft.com/k8se/quickstart:latest"
#       cpu    = 0.25
#       memory = "0.5Gi"
#     }
#     cooldown_period_in_seconds = 900 # 15 minutes
#   }

#   ingress {
#     target_port      = 8457
#     external_enabled = true
#     traffic_weight {
#       latest_revision = true
#       percentage      = 100
#     }
#   }

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.id.id]
#   }

#   lifecycle {
#     ignore_changes = [
#       template[0].container
#     ]
#   }

#   secret {
#     name                = "azure-openai-api-key"
#     identity            = azurerm_user_assigned_identity.id.id
#     key_vault_secret_id = azurerm_key_vault_secret.azure-openai-api-key.versionless_id
#   }
#   secret {
#     name                = "jwt-secret-key"
#     identity            = azurerm_user_assigned_identity.id.id
#     key_vault_secret_id = azurerm_key_vault_secret.jwt-secret-key.versionless_id
#   }
#   secret {
#     name                = "database-url"
#     identity            = azurerm_user_assigned_identity.id.id
#     key_vault_secret_id = azurerm_key_vault_secret.database-url.versionless_id
#   }
#   secret {
#     name                = "communication-service-connection-string"
#     identity            = azurerm_user_assigned_identity.id.id
#     key_vault_secret_id = azurerm_key_vault_secret.communication-service-connection-string.versionless_id
#   }
#   secret {
#     name                = "storage-account-connection-string"
#     identity            = azurerm_user_assigned_identity.id.id
#     key_vault_secret_id = azurerm_key_vault_secret.storage-account-connection-string.versionless_id
#   }
#   secret {
#     name                = "azure-openai-api-key-fallback"
#     identity            = azurerm_user_assigned_identity.id.id
#     key_vault_secret_id = azurerm_key_vault_secret.azure-openai-api-key-fallback.versionless_id
#   }
#   depends_on = [azurerm_role_assignment.key_vault_id]
# }
