
output "vm_identities" {
  value = {
    frontend = azurerm_linux_virtual_machine.frontendvm.identity[0].principal_id
    backend  = azurerm_linux_virtual_machine.backendvm.identity[0].principal_id
  }
}

output "vm_ids" {
  value = [
    azurerm_linux_virtual_machine.frontendvm.id,
    azurerm_linux_virtual_machine.backendvm.id
  ]
}