# create firewall vnet and subnet
resource "azurerm_virtual_network" "fw_vnet" {
  name                = var.fw_vnet_name
  resource_group_name = var.fw_resource_group
  address_space       = [var.fw_vnet_range]
  location            = var.fw_location
}

resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.fw_resource_group
  virtual_network_name = azurerm_virtual_network.fw_vnet.name
  address_prefix       = var.fw_subnet_range
}

# peer firewall vnet with the hostpool vnet
resource "azurerm_virtual_network_peering" "fw-vnet-to-hostpool" {
  name                      = "fw-vnet-to-hostpool"
  resource_group_name       = var.fw_resource_group
  virtual_network_name      = azurerm_virtual_network.fw_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.vnet_to_peer_with.id
}

resource "azurerm_virtual_network_peering" "hostpool-vnet-to-fw" {
  name                      = "hostpool-vnet-to-fw"
  resource_group_name       = var.fw_vnet_resource_group_to_peer_with
  virtual_network_name      = var.fw_vnet_name_to_peer_with
  remote_virtual_network_id = azurerm_virtual_network.fw_vnet.id
}

# create azure firewall
resource "azurerm_public_ip" "fw_pip" {
  name                = var.fw_pip_name
  location            = var.fw_location
  resource_group_name = var.fw_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = var.fw_name
  location            = var.fw_location
  resource_group_name = var.fw_resource_group

  ip_configuration {
    name                 = "azfw-ip-config"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}

