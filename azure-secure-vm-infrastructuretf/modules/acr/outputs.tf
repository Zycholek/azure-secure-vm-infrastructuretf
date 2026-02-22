output "acr_id" {
  description = "ACR resource ID"
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  description = "ACR login server"
  value       = azurerm_container_registry.acr.login_server
}

output "name" {
  description = "ACR name"
  value       = azurerm_container_registry.acr.name
}

output "admin_username" {
  value = azurerm_container_registry.acr.name
}

output "admin_password" {
  value = azurerm_container_registry.acr.admin_password
}

