# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  features {}
  subscription_id = "eb2cf854-8c12-4583-97bf-43bf12f1a688" # waad test
  tenant_id = "3fd11e85-d8ce-4c7f-b6a0-816346615777"       # xstof.xyz
  storage_use_azuread = false                              # does not seem to work ?
}

# set storage account access key in powershell like: $Env:ARM_ACCESS_KEY = "..."  
terraform {
  backend "azurerm" {
    subscription_id         = "eb2cf854-8c12-4583-97bf-43bf12f1a688"
    tenant_id               = "3fd11e85-d8ce-4c7f-b6a0-816346615777"
    resource_group_name     = "xstof-wvd-tf"
    storage_account_name    = "xstofwvdtf"
    container_name          = "terraformstate"
    key                     = "terraform.tfstate"
  }
}

# Create a resource group
resource "azurerm_resource_group" "azurefirewall" {
  name     = var.fw_resource_group
  location = var.fw_location
}

# Firewall - subnet
module "firewall" {
  source = "../modules/firewall"

  fw_resource_group                     = azurerm_resource_group.azurefirewall.name
  fw_location                           = azurerm_resource_group.azurefirewall.location

  fw_subnet_range                       = var.fw_subnet_range
  fw_vnet_name                          = var.fw_vnet_name
  fw_vnet_range                         = var.fw_vnet_range
  fw_vnet_name_to_peer_with             = var.fw_vnet_name_to_peer_with
  fw_vnet_resource_group_to_peer_with   = var.fw_vnet_resource_group_to_peer_with
  fw_pip_name                           = var.fw_pip_name

  fw_name                               = var.fw_name
}