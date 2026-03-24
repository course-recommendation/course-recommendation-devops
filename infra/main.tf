terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.55.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "stcourserecomcicd"
    use_azuread_auth     = true
    key                  = "terraform.tfstate"
    container_name       = "tfstate"
  }
}
