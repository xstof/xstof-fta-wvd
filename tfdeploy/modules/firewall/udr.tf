# create routing table:
resource "azurerm_route_table" "fw_udr" {
  name                          = "${var.fw_name}-udr"
  location                      = data.azurerm_virtual_network.vnet_to_peer_with.location
  resource_group_name           = var.fw_vnet_resource_group_to_peer_with
  disable_bgp_route_propagation = false

  route {
    name                    = "all-through-azure-fw"
    address_prefix          = "0.0.0.0/0"
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }

  tags = {
    environment = "Production"
  }
}

# associate routing table with subnet:
resource "azurerm_subnet_route_table_association" "fw_udr_association" {
  subnet_id      = data.azurerm_subnet.fw_subnet_to_route_traffic_from_to_fw.id
  route_table_id = azurerm_route_table.fw_udr.id
}