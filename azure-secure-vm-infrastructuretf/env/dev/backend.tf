terraform {
  backend "azurerm" {
    resource_group_name  = "tfproject-SA-rg"
    storage_account_name = "tfproject01storage"
    container_name       = "tfstate"
    key                  = "infrastructure.tfstate"
  }
}