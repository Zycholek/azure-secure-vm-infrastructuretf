output "public_ip_address" {
  value = azurerm_public_ip.frontend_ip.ip_address
}

output "public_ip_id" {
  value = azurerm_public_ip.frontend_ip.id
}

output "lb_id" {
  value = azurerm_lb.load_balancer.id
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.be_pool.id
}