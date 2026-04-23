resource "azurerm_container_app" "ca_ai" {
  name                         = "ca-${local.project_name}-ai"
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
    target_port      = 8000
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
    name                = "openai-api-key"
    identity            = azurerm_user_assigned_identity.id.id
    key_vault_secret_id = azurerm_key_vault_secret.openai-api-key.versionless_id
  }
  secret {
    name                = "azure-storage-connection-string"
    identity            = azurerm_user_assigned_identity.id.id
    key_vault_secret_id = azurerm_key_vault_secret.azure-storage-connection-string.versionless_id
  }

  depends_on = [azurerm_role_assignment.key_vault_id]
}

resource "azurerm_dns_txt_record" "ca_txt_ai" {
  name                = "asuid.ai"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 3600
  record {
    value = azurerm_container_app.ca_ai.custom_domain_verification_id
  }
}

resource "azurerm_dns_cname_record" "ca_cname_ai" {
  name                = "ai"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 3600
  record              = "${azurerm_container_app.ca_ai.name}.${azurerm_container_app_environment.cae.default_domain}"
}

resource "azurerm_container_app_custom_domain" "ca_ai_custom_domain" {
  name             = "${azurerm_dns_cname_record.ca_cname_ai.name}.${azurerm_dns_zone.dns_zone.name}"
  container_app_id = azurerm_container_app.ca_ai.id

  lifecycle {
    // When using an Azure created Managed Certificate these values must be added to ignore_changes to prevent resource recreation.
    ignore_changes = [certificate_binding_type, container_app_environment_certificate_id]
  }
}

resource "azapi_resource" "managed_cert_ai" {
  type      = "Microsoft.App/managedEnvironments/managedCertificates@2025-07-01"
  name      = azurerm_container_app_custom_domain.ca_ai_custom_domain.name
  parent_id = azurerm_container_app_environment.cae.id
  location  = azurerm_resource_group.rg.location

  body = {
    properties = {
      subjectName             = azurerm_container_app_custom_domain.ca_ai_custom_domain.name
      domainControlValidation = "CNAME"
    }
  }
}

resource "azapi_update_resource" "bind_domain_ai" {
  type        = "Microsoft.App/containerApps@2025-07-01"
  resource_id = azurerm_container_app.ca_ai.id

  body = {
    properties = {
      configuration = {
        ingress = {
          customDomains = [
            {
              name          = azurerm_container_app_custom_domain.ca_ai_custom_domain.name
              bindingType   = "SniEnabled"
              certificateId = azapi_resource.managed_cert_ai.id
            }
          ]
        }
      }
    }
  }
}