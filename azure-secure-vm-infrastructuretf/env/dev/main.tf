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

  resource_group_name    = var.resource_group_name
  my_ip                  = var.my_ip
  vnet_address_space     = var.vnet_address_space
  location               = var.location
  frontend_subnet_prefix = var.frontend_subnet_prefix
  backend_subnet_prefix  = var.backend_subnet_prefix

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
  resource_group_name  = module.network.resource_group_name
  location             = module.network.location
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  admin_ssh_public_key = file("C:/Users/user/.ssh/myfrontvmkey.pub")
  tags                 = var.tags
}


module "keyvault" {
  source              = "../../modules/keyvault"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  key_vault_name      = var.key_vault_name
  env                 = var.env
  vm_identities       = module.vm.vm_identities
  tags                = var.tags

  depends_on = [
    module.network
  ]

}

module "monitoring" {
  source              = "../../modules/monitoring"
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  log_analytics_name  = var.log_analytics_name
  env                 = var.env
  retention_in_days   = 30

  vm_ids = module.vm.vm_ids
  tags   = var.tags

  nsg_ids = {
    backend  = module.network.dev_backend_nsg
    frontend = module.network.dev_frontend_nsg
  }



  vnet_id      = module.network.vnet_id
  key_vault_id = module.keyvault.key_vault_id

}

module "loadbalancing" {
  source              = "../../modules/loadbalancing"

  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  lb_name             = var.lb_name
  public_ip_name      = var.public_ip_name
  env                 = var.env

  tags = var.tags

  frontend_nic_id = module.vm.frontend_nic_id

}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

module "acr" {
  source = "../../modules/acr"

  name = var.acr_name
  resource_group_name = module.network.resource_group_name
  location            = module.network.location

}



module "aci" {
  source = "../../modules/aci"

  name = var.aci_name
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  container_name      = var.container_name

  acr_login_server = module.acr.login_server
  image_name = var.image_name 
  image_tag = var.image_tag

   dns_name_label      = "aci-${random_string.suffix.result}"

  port = var.container_port
  cpu = var.container_cpu
  memory = var.container_memory

acr_admin_username = module.acr.admin_username
  acr_admin_password = module.acr.admin_password
}

resource "azurerm_role_assignment" "aci_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aci.identity_principal_id

  depends_on = [
    module.aci
  ]
}



