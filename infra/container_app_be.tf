resource "azurerm_container_app_environment" "cae" {
  name                       = "cae-${local.project_name}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
  workload_profile {
    maximum_count         = 0
    minimum_count         = 0
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
  infrastructure_subnet_id = azurerm_subnet.subnet_ca.id
  lifecycle {
    ignore_changes = [ infrastructure_resource_group_name ]
  }
}

resource "azurerm_container_app" "ca" {
  name                         = "ca-${local.project_name}"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = azurerm_container_app_environment.cae.resource_group_name
  revision_mode                = "Single"

  workload_profile_name = "Consumption"

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
      template[0].container,
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

resource "azurerm_dns_txt_record" "ca_txt" {
  name                = "asuid.api"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 3600
  record {
    value = azurerm_container_app.ca.custom_domain_verification_id
  }
}

resource "azurerm_dns_cname_record" "ca_cname" {
  name                = "api"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 3600
  record              = "${azurerm_container_app.ca.name}.${azurerm_container_app_environment.cae.default_domain}"
}

resource "azurerm_container_app_custom_domain" "ca_custom_domain" {
  name             = "${azurerm_dns_cname_record.ca_cname.name}.${azurerm_dns_zone.dns_zone.name}"
  container_app_id = azurerm_container_app.ca.id

  lifecycle {
    // When using an Azure created Managed Certificate these values must be added to ignore_changes to prevent resource recreation.
    ignore_changes = [certificate_binding_type, container_app_environment_certificate_id]
  }
}

resource "azapi_resource" "managed_cert" {
  type      = "Microsoft.App/managedEnvironments/managedCertificates@2025-07-01"
  name      = azurerm_container_app_custom_domain.ca_custom_domain.name
  parent_id = azurerm_container_app_environment.cae.id
  location  = azurerm_resource_group.rg.location

  body = {
    properties = {
      subjectName             = azurerm_container_app_custom_domain.ca_custom_domain.name
      domainControlValidation = "CNAME"
    }
  }
}

resource "azapi_update_resource" "bind_domain" {
  type        = "Microsoft.App/containerApps@2025-07-01"
  resource_id = azurerm_container_app.ca.id

  body = {
    properties = {
      configuration = {
        ingress = {
          customDomains = [
            {
              name          = azurerm_container_app_custom_domain.ca_custom_domain.name
              bindingType   = "SniEnabled"
              certificateId = azapi_resource.managed_cert.id
            }
          ]
        }
      }
    }
  }
}

resource "azapi_resource_action" "unbind_domain_on_destroy" {
  type        = "Microsoft.App/containerApps@2025-07-01"
  resource_id = azurerm_container_app.ca.id
  method      = "PATCH"
  when        = "destroy"

  body = {
    properties = {
      configuration = {
        ingress = {
          customDomains = [
            {
              name        = azurerm_container_app_custom_domain.ca_custom_domain.name
              bindingType = "Disabled"
            }
          ]
        }
      }
    }
  }
  depends_on = [ azapi_resource.managed_cert ]
}
