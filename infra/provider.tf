provider "azurerm" {
  features {
  }
}

data "azurerm_client_config" "current" {}

provider "github" {
  owner = "course-recommendation"
  token = var.github_token
}
