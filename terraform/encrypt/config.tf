terraform {
  required_providers {
    azurerm    = {
      source   = "hashicorp/azurerm"
    }
    sops       = {
      source = "carlpett/sops"
    }
  }
}
provider "azurerm" {
  features {}
}