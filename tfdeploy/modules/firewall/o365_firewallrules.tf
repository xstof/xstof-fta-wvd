locals {
  source_addresses = "10.1.0.0/16"
  http_https_o365_rules = {for r in jsondecode(data.http.o365_urls_to_whitelist.body): "${r.id}-${r.serviceArea}" => 
    {
      rulename  = "${r.id}-${r.serviceArea}"
      urls      = try(r.urls, [])
      id        = r.id,
      tcpPorts  = try(split(",", r.tcpPorts), [])
    }
    if length(try(r.urls, [])) > 0 && length(setintersection(toset(try(split(",", r.tcpPorts), [])), [80, 443])) > 0
  }
  other_0365_rules = {for r in jsondecode(data.http.o365_urls_to_whitelist.body): "${r.id}-${r.serviceArea}" => r
    if length(try(r.urls, [])) == 0 || length(setintersection(toset(try(split(",", r.tcpPorts), [])), [80, 443])) == 0
  }
  protocols = {
    "80"  = "Http"
    "443" = "Https"
  }
}

resource "azurerm_firewall_network_rule_collection" "fw_o365_network_rules" {
  name                = "allow_all_0365_ips"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.fw_resource_group
  priority            = 101
  action              = "Allow"
  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
    read = "2h"
  }

  dynamic "rule" {
    for_each = local.other_0365_rules

    content {
      name = "${rule.value.id}-${rule.value.serviceArea}"

      source_addresses = [
        local.source_addresses
      ]

      destination_ports = concat(try(split(",", rule.value.tcpPorts), []), try(split(",", rule.value.udpPorts), []))
      # filter out ipv6 addresses:
      destination_addresses = [for p in rule.value.ips: p if replace(p, ":", "") == p] 
      protocols = compact(split(",", "${length(try(rule.value.tcpPorts, [])) > 0 ? "TCP" : ""},${length(try(rule.value.udpPorts, [])) > 0 ? "UDP" : ""}"))
    }
    
  }
}

resource "azurerm_firewall_application_rule_collection" "fw_o365_app_rules" {
  name                = "allow_all_o365_urls"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.fw_resource_group
  priority            = 300
  action              = "Allow"
  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
    read = "2h"
  }

  # see https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
  dynamic "rule" {
    for_each = local.http_https_o365_rules

    content {
      name = rule.key

      source_addresses = [
        local.source_addresses
      ]
      
      target_fqdns = rule.value.urls

      dynamic "protocol" {
        for_each = [for p in rule.value.tcpPorts: p]

        content {
          port = protocol.value
          type = lookup(local.protocols, protocol.value, "fail")
        }
        
      }
    }
  
  }
}