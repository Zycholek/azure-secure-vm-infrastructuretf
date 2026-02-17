resource "azurerm_log_analytics_workspace" "la_workspace" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
}

resource "azurerm_monitor_diagnostic_setting" "vm" {
  for_each = var.vm_ids

  name                       = "diag-vm-${replace(each.key, "/", "-")}"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_workspace.id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = "diag-kv"
  target_resource_id         = var.key_vault_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_workspace.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  for_each = var.nsg_ids

  name                       = "diag-nsg-${replace(each.key, "/", "-")}"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_workspace.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

resource "azurerm_monitor_diagnostic_setting" "vnet" {
  name                       = "diag-vnet"
  target_resource_id         = var.vnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_workspace.id

  enabled_metric {
    category = "AllMetrics"
  }
}