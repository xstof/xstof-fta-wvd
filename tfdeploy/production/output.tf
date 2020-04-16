output "o365_urls" {
  value = module.firewall.o365_urls
}

output "other" {
  value = {for r in module.firewall.o365_urls: "${r.id}-${r.serviceArea}" => r}
}

output "o365_rules_without_url" {
  value = module.firewall.o365_rules_without_url
}

output "o365_rules_other_than_http_https" {
  value = module.firewall.o365_rules_with_other_than_http_https
}