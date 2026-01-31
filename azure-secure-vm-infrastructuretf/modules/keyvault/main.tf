
data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "kv" {
  name                        = "tfproject${var.env}KV"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  tags = var.tags
}

  resource "azurerm_key_vault_access_policy" "vm_access" {
  for_each = var.vm_identities

  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

    secret_permissions = [
      "Get",
      "List"
    ]

    
  }
