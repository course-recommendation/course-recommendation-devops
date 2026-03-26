resource "azurerm_container_app_environment" "cae" {
  name                       = "cae-${local.project_name}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app" "ca" {
  name                         = "ca-${local.project_name}"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = azurerm_container_app_environment.cae.resource_group_name
  revision_mode                = "Single"

  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.id.id
  }

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
    cooldown_period_in_seconds = 300
  }

  ingress {
    target_port      = 8082
    external_enabled = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.id.id]
  }

  lifecycle {
    ignore_changes = [
      template[0].container
    ]
  }

  secret {
    name                = "mysql-database-name"
    identity            = azurerm_user_assigned_identity.id.id
    key_vault_secret_id = azurerm_key_vault_secret.mysql-database-name.versionless_id
  }
  secret {
    name                = "mysql-url"
    identity            = azurerm_user_assigned_identity.id.id
    key_vault_secret_id = azurerm_key_vault_secret.mysql-url.versionless_id
  }
  secret {
    name                = "mysql-username"
    identity            = azurerm_user_assigned_identity.id.id
    key_vault_secret_id = azurerm_key_vault_secret.mysql-username.versionless_id
  }
  secret {
    name                = "mysql-root-password"
    identity            = azurerm_user_assigned_identity.id.id
    key_vault_secret_id = azurerm_key_vault_secret.mysql-root-password.versionless_id
  }
  depends_on = [azurerm_role_assignment.key_vault_id]
}