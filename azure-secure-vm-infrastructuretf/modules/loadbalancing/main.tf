resource "azurerm_public_ip" "frontend_ip" {
  name                = "lb-pip-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "load_balancer" {
  name                = "load-balancer-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku = "Standard"
  

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.frontend_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "be_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "lb-be-pool"
}


resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "http-probe"
  protocol            = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"

  backend_address_pool_ids       = [
    azurerm_lb_backend_address_pool.be_pool.id
  ]

  probe_id                       = azurerm_lb_probe.http_probe.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_be_assoc" {
  network_interface_id    = var.frontend_nic_id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.be_pool.id
}
