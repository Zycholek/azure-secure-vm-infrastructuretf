

resource "azurerm_public_ip" "frontendvm_pip" {
  name                = "${var.vm_names.frontendvm}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_network_interface" "frontendvm_nic" {
  name                = "${var.vm_names.frontendvm}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.frontend_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.frontendvm_pip.id
  }

  tags = var.tags
}


resource "azurerm_linux_virtual_machine" "frontendvm" {
  name                = var.vm_names.frontendvm
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.frontendvm_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}







# Placeholder for cloud-init
  # custom_data = filebase64("${path.module}/cloud-init.yaml")

  

resource "azurerm_network_interface" "backendvm_nic" {
  name                = "${var.vm_names.backendvm}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
    
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "backendvm" {
  name                = var.vm_names.backendvm
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.backendvm_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}





# Placeholder for cloud-init
  # custom_data = filebase64("${path.module}/cloud-init.yaml")

  








