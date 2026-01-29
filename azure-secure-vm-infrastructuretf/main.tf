# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }

}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}



resource "azurerm_resource_group" "tfproject-dev-rg" {
  name     = "tfproject-rg"
  location = var.location
}


module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.tfproject-dev-rg.name
  my_ip = var.my_ip
  vnet_address_space = var.vnet_address_space
  location            = var.location

}


module "frontend_vm" {
  source = "./modules/vm"
  vm_name              = "dev-frontend-vm"
  vm_size              = "Standard_B2s"
  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key

  subnet_id        = module.network.dev-subnet-frontend-01.id
  assign_public_ip = true

  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  tags                = var.tags
}

module "backend_vm" {
  source = "./modules/vm"

  vm_name              = "dev-backend-vm"
  vm_size              = "Standard_B2s"
  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key

  subnet_id        = module.network.backend_subnet_id
  assign_public_ip = false

  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  tags                = var.tags
}
