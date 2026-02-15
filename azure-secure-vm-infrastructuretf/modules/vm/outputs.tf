
output "vm_identities" {
  value = {
    frontend = azurerm_linux_virtual_machine.frontendvm.identity[0].principal_id
    backend  = azurerm_linux_virtual_machine.backendvm.identity[0].principal_id
  }
}

output "vm_ids" {
  value = {
    backend  = azurerm_linux_virtual_machine.backendvm.id
    frontend = azurerm_linux_virtual_machine.frontendvm.id
  }
}

output "frontend_nic_id" {
  value = azurerm_network_interface.frontendvm_nic.id
}

output "backend_nic_id" {
  value = azurerm_network_interface.backendvm_nic.id
}
