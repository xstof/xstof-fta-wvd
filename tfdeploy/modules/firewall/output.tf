output "o365_urls" {
  value = jsondecode(data.http.o365_urls_to_whitelist.body)
}

output "o365_rules_without_url" {
  value = {for r in jsondecode(data.http.o365_urls_to_whitelist.body): "${r.id}-${r.serviceArea}" => r
      if length(try(r.urls, [])) == 0
  }
}

output "o365_rules_with_other_than_http_https" {
  value = {for r in jsondecode(data.http.o365_urls_to_whitelist.body): "${r.id}-${r.serviceArea}" => r
      if length(setintersection(toset(try(split(",", r.tcpPorts), [])), [80, 443])) == 0
  }
}