[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string]$TenantName="xstof-wvd",

  [Parameter(Mandatory=$False)]
  [string]$RGName="xstof-wvd-hostpool",

  [Parameter(Mandatory=$False)]
  [string]$HostPoolName="xstof-wvd-hostpool",

  [Parameter(Mandatory=$False)]
  [string]$AppGroupName="Desktop Application Group",

  [Parameter(Mandatory=$False)]
  [string]$AADTenantId="3fd11e85-d8ce-4c7f-b6a0-816346615777"
)

# Run this first: Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

# Remove App Group Users:
$AppGroupUsers = Get-RdsAppGroupUser -TenantName $TenantName -HostPoolName $HostPoolName -AppGroupName $AppGroupName
$AppGroupUsers | Remove-RdsAppGroupUser

# Remove App Group:
Remove-RdsAppGroup -TenantName $TenantName -HostPoolName $HostPoolName -Name $AppGroupName

# Remove Session Hosts from Host Pool:
$Hosts = Get-RdsSessionHost -TenantName $TenantName -HostPoolName $HostPoolName
$Hosts | Remove-RdsSessionHost # as long as there's session active, this does not seem to work

# Remove HostPool:
Remove-RdsHostPool -TenantName $TenantName -Name $HostPoolName