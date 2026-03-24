# resource "azurerm_dns_zone" "dns_zone" {
#   name                = var.domain_name
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_dns_txt_record" "eacsd_domain" {
#   name                = "@"
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
#   ttl                 = azurerm_email_communication_service_domain.eacsd.verification_records[0].domain[0].ttl

#   record {
#     value = azurerm_email_communication_service_domain.eacsd.verification_records[0].domain[0].value
#   }
#   record {
#     value = azurerm_email_communication_service_domain.eacsd.verification_records[0].spf[0].value
#   }
# }

# resource "azurerm_dns_cname_record" "eacsd_dkim" {
#   name                = azurerm_email_communication_service_domain.eacsd.verification_records[0].dkim[0].name
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
#   ttl                 = azurerm_email_communication_service_domain.eacsd.verification_records[0].dkim[0].ttl
#   record              = azurerm_email_communication_service_domain.eacsd.verification_records[0].dkim[0].value
# }

# resource "azurerm_dns_cname_record" "eacsd_dkim2" {
#   name                = azurerm_email_communication_service_domain.eacsd.verification_records[0].dkim2[0].name
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
#   ttl                 = azurerm_email_communication_service_domain.eacsd.verification_records[0].dkim2[0].ttl
#   record              = azurerm_email_communication_service_domain.eacsd.verification_records[0].dkim2[0].value
# }

# resource "azurerm_dns_txt_record" "ca_txt" {
#   name                = "asuid.api"
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
#   ttl                 = 3600
#   record {
#     value = azurerm_container_app.ca.custom_domain_verification_id
#   }
# }

# resource "azurerm_dns_cname_record" "ca_cname" {
#   name                = "api"
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
#   ttl                 = 3600
#   record              = "${azurerm_container_app.ca.name}.${azurerm_container_app_environment.cae.default_domain}"
# }
