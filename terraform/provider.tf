terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "~> 2.23.0"
    }
  }
}

provider "azurerm" {
  features {}
}
