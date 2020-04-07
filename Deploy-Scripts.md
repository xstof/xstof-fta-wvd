# WVD Deployment Scripts

## Deploy a new Host Pool

Mandatory params:
- DomainJoinerPasswordPlain (pwd for user that is allowd to join domain)
- TenantAdminPasswordPlain (pwd for the WVD service principal)

~~~powershell
.\deploy-hostpool.ps1 -DomainJoinerPasswordPlain "password" -TenantAdminPasswordPlain "yjrWhPoiU...nGteU="
~~~

## Update an existing Host Pool

Based on this ARM template: https://github.com/Azure/RDS-Templates/blob/master/wvd-templates/Update%20existing%20WVD%20host%20pool/mainTemplate.json

> Attention: make sure that the VM prefix is *different* from the existing VM prefix or _nothing_ will happen

Mandatory params:
- DomainJoinerPasswordPlain (pwd for user that is allowd to join domain)
- TenantAdminPasswordPlain (pwd for the WVD service principal)

~~~powershell
.\update-hostpool.ps1 -DomainJoinerPasswordPlain "password" -TenantAdminPasswordPlain "yjrWhPoiU...nGteU=" -HostPoolVMPrefix "xstof-wvd-vm-updated"
~~~