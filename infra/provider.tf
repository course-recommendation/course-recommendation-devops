provider "azurerm" {
  features {
  }
  storage_use_azuread = true
}

data "azurerm_client_config" "current" {}

provider "github" {
  owner = "course-recommendation"
  token = var.github_token
}
