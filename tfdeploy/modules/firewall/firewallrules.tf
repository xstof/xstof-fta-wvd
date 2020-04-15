resource "azurerm_firewall_network_rule_collection" "fw_rules" {
  name                = "allow_all"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.fw_resource_group
  priority            = 100
  action              = "Allow"

  rule {
    name = "allow_all"

    source_addresses = [
      "10.1.0.0/16",
    ]

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      "0.0.0.0/0",
    ]

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}