data "azurerm_virtual_network" "vnet_to_peer_with" {
  name                = var.fw_vnet_name_to_peer_with
  resource_group_name = var.fw_vnet_resource_group_to_peer_with
}