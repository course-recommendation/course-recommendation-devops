resource "azurerm_storage_account" "st" {
  name                     = "st${local.project_name}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  blob_properties {
    versioning_enabled = true
  }
  shared_access_key_enabled = false
}

resource "azurerm_storage_management_policy" "st_policy" {
  storage_account_id = azurerm_storage_account.st.id

  rule {
    name    = "DeletePreviousVersions"
    enabled = true
    filters {
      blob_types = ["blockBlob", "appendBlob"]
    }
    actions {
      version {
        delete_after_days_since_creation = 30
      }
    }
  }
}
