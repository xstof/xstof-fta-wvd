data "azurerm_virtual_network" "vnet_to_peer_with" {
  name                = var.fw_vnet_name_to_peer_with
  resource_group_name = var.fw_vnet_resource_group_to_peer_with
}

data "azurerm_subnet" "fw_subnet_to_route_traffic_from_to_fw" {
  name                 = var.fw_subnet_to_route_traffic_from_to_fw
  virtual_network_name = var.fw_vnet_name_to_peer_with
  resource_group_name  = var.fw_vnet_resource_group_to_peer_with
}

# O365 URLs and ips to whitelist, see:
# - https://docs.microsoft.com/en-us/office365/enterprise/urls-and-ip-address-ranges
# - https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7

data "http" "o365_urls_to_whitelist" {
  url = "https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}