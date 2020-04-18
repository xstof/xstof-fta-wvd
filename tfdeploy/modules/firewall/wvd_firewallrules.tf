locals {
  wvd_source_addresses = "10.1.0.0/16"
  wdv_protocols = {
    "80"  = "Http"
    "443" = "Https"
  }

  #see: https://docs.microsoft.com/en-us/azure/virtual-desktop/overview#requirements

  wvdNetworkRules = [
    {
        "url"             =   "kms.core.windows.net"
        "tcpPort"         =   1688
    }
  ]

  wvdAppRules = [
    {
        "url"             =   "*.wvd.microsoft.com"
        "tcpPort"         =   443
    },
    {
        "url"             =   "mrsglobalsteus2prod.blob.core.windows.net"
        "tcpPort"         =   443
    },
    {
        "url"             =   "*.core.windows.net"
        "tcpPort"         =   443
    },
    {
        "url"             =   "*.servicebus.windows.net"
        "tcpPort"         =   443
    },
    {
        "url"             =   "prod.warmpath.msftcloudes.com"
        "tcpPort"         =   443
    },
    {
        "url"             =   "catalogartifact.azureedge.net"
        "tcpPort"         =   443
    }
  ]

  otherAppRules = [
    {
        "url"             =   "*.microsoftonline.com"
        "tcpPort"         =   443
    },
    {
        "url"             =   "*.events.data.microsoft.com"
        "tcpPort"         =   443
    },
    {
        "url"             =   "www.msftconnecttest.com"
        "tcpPort"         =   443
    },
    {
        "url"             =   "*.prod.do.dsp.mp.microsoft.com"
        "tcpPort"         =   443
    },
    {
        "url"             =   "login.windows.net"
        "tcpPort"         =   443
    },
    {
        "url"             =   "*.sfx.ms"
        "tcpPort"         =   443
    },
    {
        "url"             =   "*.digicert.com"
        "tcpPort"         =   443
    }
  ]
}

resource "azurerm_firewall_application_rule_collection" "fw_wvd_app_rules" {
  name                = "allow_all_wvd_urls"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.fw_resource_group
  priority            = 400
  action              = "Allow"
  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
    read = "2h"
  }

  # see https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
  dynamic "rule" {
    for_each = local.wvdAppRules

    content {
      name = rule.value.url

      source_addresses = [
        local.wvd_source_addresses
      ]
      
      target_fqdns = [ rule.value.url ]

      protocol {
        port = rule.value.tcpPort
        type = lookup(local.wdv_protocols, rule.value.tcpPort, "fail")
      }
    }
  
  }
}


resource "azurerm_firewall_application_rule_collection" "fw_wvd_other_app_rules" {
  name                = "allow_other_wvd_urls"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.fw_resource_group
  priority            = 500
  action              = "Allow"
  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
    read = "2h"
  }

  # see https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
  dynamic "rule" {
    for_each = local.otherAppRules

    content {
      name = rule.value.url

      source_addresses = [
        local.wvd_source_addresses
      ]
      
      target_fqdns = [ rule.value.url ]

      protocol {
        port = rule.value.tcpPort
        type = lookup(local.wdv_protocols, rule.value.tcpPort, "fail")
      }
    }
  
  }
}

resource "azurerm_firewall_network_rule_collection" "fw_wvd_network_rules" {
  name                = "allow_all_wvd_ips"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.fw_resource_group
  priority            = 150
  action              = "Allow"
  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
    read = "2h"
  }

  dynamic "rule" {
    for_each = local.wvdNetworkRules

    content {
      name = rule.value.url

      source_addresses = [
          local.wvd_source_addresses
      ]

      destination_ports = [ rule.value.tcpPort ]
      destination_addresses = [ "*" ]
      protocols = ["Any"]
    }
    
  }
}