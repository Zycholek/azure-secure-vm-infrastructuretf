resource "azurerm_resource_group" "tfproject_dev_rg" {
  name     = var.resource_group_name
  location = var.location
  
}

resource "azurerm_virtual_network" "tfproject_dev_vnet" {
  name                = "tfproject-dev-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = {
  environment = "dev"

}
}
  

  resource "azurerm_subnet" "dev_subnet_frontend_01" {
    name             = "dev-subnet-frontend-01"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.tfproject_dev_vnet.name
    address_prefixes = var.frontend_subnet_prefix
   

  }

resource "azurerm_subnet" "dev_subnet_backend_01" {
    name             = "dev-subnet-backend-01"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.tfproject_dev_vnet.name
    address_prefixes = var.backend_subnet_prefix

  

  }



resource "azurerm_network_security_group" "dev_frontend_nsg" {
  name                = "dev-frontend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags


  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"      # frontend subnet CIDR
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"      # frontend subnet CIDR
  }

security_rule {
  name                       = "Allow-SSH-From-My-IP"
  priority                   = 120
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = var.my_ip      # My IP
  destination_address_prefix = "*"      # frontend subnet CIDR
  
  
}

 security_rule {
    name                       = "Allow-LB-To-VM-SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Internet-NAT-Port"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "50001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_subnet_network_security_group_association" "front_front_association" {
  subnet_id                 = azurerm_subnet.dev_subnet_frontend_01.id
  network_security_group_id = azurerm_network_security_group.dev_frontend_nsg.id
  

  
}


 resource "azurerm_network_security_group" "dev_backend_nsg" {
  name                = "dev-backend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags


security_rule {
  name                        = "Allow-Frontend-To-Backend"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.1.0/24"   # frontend subnet CIDR
  destination_address_prefix  = "10.0.2.0/24"   # backend subnet CIDR
}

}

resource "azurerm_subnet_network_security_group_association" "back_back_association" {
  subnet_id                 = azurerm_subnet.dev_subnet_backend_01.id
  network_security_group_id = azurerm_network_security_group.dev_backend_nsg.id



}