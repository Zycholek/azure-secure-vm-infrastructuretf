output "resource_group_name" {
  value = azurerm_resource_group.tfproject_dev_rg.name
}

output "location" {
  value = azurerm_resource_group.tfproject_dev_rg.location
}

output "dev_subnet_frontend_01_id" {
  value = azurerm_subnet.dev_subnet_frontend_01.id
}

output "dev_subnet_backend_01_id" {
  value = azurerm_subnet.dev_subnet_backend_01.id
}

output "dev_frontend_nsg" {
  value = azurerm_network_security_group.dev_frontend_nsg.id
}

output "dev_backend_nsg" {
  value = azurerm_network_security_group.dev_backend_nsg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.tfproject_dev_vnet.id
}