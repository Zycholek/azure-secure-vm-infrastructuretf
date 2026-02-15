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
  
}






module "network" {
  source = "../../modules/network"

  resource_group_name = var.resource_group_name 
  my_ip = var.my_ip
  vnet_address_space = var.vnet_address_space
  location            = var.location
  frontend_subnet_prefix = var.frontend_subnet_prefix
  backend_subnet_prefix = var.backend_subnet_prefix

  tags = var.tags
}



module "vm" {
  source = "../../modules/vm"

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
  source = "../../modules/keyvault"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  env = var.env
  vm_identities       = module.vm.vm_identities
  tags = var.tags

}

module "monitoring" {
  source = "../../modules/monitoring"
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  env                 = var.env
  retention_in_days = 30

  vm_ids = module.vm.vm_ids

  nsg_ids = {
    backend  = module.network.dev_backend_nsg
    frontend = module.network.dev_frontend_nsg
  }



  vnet_id = module.network.vnet_id
  key_vault_id = module.keyvault.key_vault_id

}

module "loadbalancing" {
  source = "../../modules/loadbalancing"

resource_group_name = module.network.resource_group_name
location = module.network.location
env = var.env

frontend_nic_id = module.vm.frontend_nic_id


}