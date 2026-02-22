resource "azurerm_container_group" "aci" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  dns_name_label = var.dns_name_label
  os_type             = "Linux"

  

  identity {
    type = "SystemAssigned"
  }

  container {
    name   = var.container_name
    image  = "${var.acr_login_server}/${var.image_name}:${var.image_tag}"
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }

  

  

}


