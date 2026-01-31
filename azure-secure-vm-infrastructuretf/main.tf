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







module "network" {
  source = "./modules/network"

  resource_group_name = var.resource_group_name 
  my_ip = var.my_ip
  vnet_address_space = var.vnet_address_space
  location            = var.location

}



module "vm" {
  source = "./modules/vm"

 # VM names
  vm_names = var.vm_names

  # Networking (coming from network module outputs)
  frontend_subnet_id = module.network.dev_subnet_frontend_01_id
  backend_subnet_id  = module.network.dev_subnet_backend_01_id


  # Common settings
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_ssh_public_key = file("C:/Users/user/.ssh/myfrontvmkey.pub")
  tags                = var.tags
}


module "keyvault" {
  source = "./modules/keyvault"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  env = var.env
  vm_identities       = module.vm.vm_identities
  tags = var.tags

}