resource "azurerm_route_table" "fw_udr" {
  name                          = "${var.fw_name}-udr"
  location                      = data.azurerm_virtual_network.vnet_to_peer_with.location
  resource_group_name           = var.fw_vnet_resource_group_to_peer_with
  disable_bgp_route_propagation = false

  route {
    name                    = "all-through-azure-fw"
    address_prefix          = "0.0.0.0/0"
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = azurerm_public_ip.fw_pip.ip_address
  }

  tags = {
    environment = "Production"
  }
}