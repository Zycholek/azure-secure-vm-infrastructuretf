output "identity_principal_id" {
  description = "System-assigned identity principal ID"
  value       = azurerm_container_group.aci.identity[0].principal_id
}

output "fqdn" {
  description = "Public FQDN of the container group (if assigned)"
  value       = azurerm_container_group.aci.fqdn
}