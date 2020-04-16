resource "azurerm_log_analytics_workspace" "fw_loganalytics" {
  name                = "${var.fw_name}-laws"
  location            = var.fw_location
  resource_group_name = var.fw_resource_group
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "fw_loganalytics_diagsetting" {
  name                            = "${var.fw_name}-la-diag"
  target_resource_id              = azurerm_firewall.fw.id
  log_analytics_workspace_id      = azurerm_log_analytics_workspace.fw_loganalytics.id
  log_analytics_destination_type  = "Dedicated"

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}