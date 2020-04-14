variable "fw_resource_group" {
  type    = string
  default = "xstof-wvd-azfirewall"
}

variable "fw_location" {
  type    = string
  default = "East US"
}

variable "fw_subnet_range" {
  type    = string
  default = "10.2.0.0/24"
}

variable "fw_vnet_name" {
  type    = string
  default = "xstof-wvd-azfw-vnet"
}

variable "fw_vnet_range" {
  type    = string
  default = "10.2.0.0/16"
}

variable "fw_vnet_name_to_peer_with" {
  type    = string
  default = "xstof-wvd-hostpool-vnet"
}

variable "fw_vnet_resource_group_to_peer_with" {
  type    = string
  default = "xstof-wvd-hostpool-vnet"
}

variable "fw_pip_name" {
  type    = string
  default = "xstof-wvd-fw-pip"
}

variable "fw_name" {
  type    = string
  default = "xstof-wvd-fw"
}