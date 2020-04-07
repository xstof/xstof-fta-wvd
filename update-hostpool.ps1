[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string]$RGName="xstof-wvd-hostpool",

  [Parameter(Mandatory=$False)]
  [string]$CustomImageName="xstof-wvd-session-host",

  [Parameter(Mandatory=$False)]
  [string]$CustomImageResourceGroup="xstof-wvd-managed-image",
  
  [Parameter(Mandatory=$False)]
  [string]$HostPoolVMPrefix="xstof-wvd-vm",

  [Parameter(Mandatory=$False)]
  [int]$NrHostInstances=1,

  [Parameter(Mandatory=$False)]
  [string]$DomainToJoin="xstof.xyz",

  [Parameter(Mandatory=$False)]
  [string]$DomainJoinerUPN="christof@xstof.xyz",

  [Parameter(Mandatory=$True)]
  [string]$DomainJoinerPasswordPlain,

  [Parameter(Mandatory=$False)]
  [string]$OUToJoin="OU=WVDSessionHosts,DC=XSTOF,DC=XYZ",

  [Parameter(Mandatory=$False)]
  [string]$VNetToJoin="xstof-wvd-hostpool-vnet",

  [Parameter(Mandatory=$False)]
  [string]$SubNetToJoin="xstof-wvd-hostpool-snet",

  [Parameter(Mandatory=$False)]
  [string]$VNetToJoinResourceGroup="xstof-wvd-hostpool-vnet",

  [Parameter(Mandatory=$False)]
  [string]$WvdTenantName="xstof-wvd",

  [Parameter(Mandatory=$False)]
  [string]$HostPoolName="xstof-wvd-hostpool",

  # These below params are only valid when creating a new hostpool - not for update:
  # [Parameter(Mandatory=$False)]
  # [string]$DefaultUsers="liss@xstof.xyz,timo@xstof.xyz",

  [Parameter(Mandatory=$False)]
  [string]$TenantAdminAppId="43b2ddf9-7a61-47ec-b43b-a445b26d83c9",

  [Parameter(Mandatory=$True)]
  [string]$TenantAdminPasswordPlain,

  [Parameter(Mandatory=$False)]
  [string]$AADTenantId="3fd11e85-d8ce-4c7f-b6a0-816346615777", #xstofaad (xstof.xyz)

  [Parameter(Mandatory=$False)]
  [int]$UserLogoffDelayInMinutes=1
)


New-AzResourceGroupDeployment -Name "WVD-Hostpool-Update" -ResourceGroupName $RGName -TemplateFile ./templates/update-hostpool.json -rdshImageSource "CustomImage" -rdshCustomImageSourceName $CustomImageName -rdshCustomImageSourceResourceGroup $CustomImageResourceGroup -rdshNamePrefix $HostPoolVMPrefix -rdshNumberOfInstances $NrHostInstances -rdshVMDiskType "StandardSSD_LRS" -rdshVmSize "Standard_D2s_v3" -domainToJoin $DomainToJoin -existingDomainUPN $DomainJoinerUPN -existingDomainPassword $(ConvertTo-SecureString -String $DomainJoinerPasswordPlain -AsPlainText -Force) -ouPath $OUToJoin -existingVnetName $VNetToJoin -newOrExistingVnet "existing" -existingSubnetName $SubNetToJoin -virtualNetworkResourceGroupName $VNetToJoinResourceGroup -existingTenantName $WvdTenantName -existingHostpoolName $HostPoolName -enablePersistentDesktop $False -tenantAdminUpnOrApplicationId $TenantAdminAppId -tenantAdminPassword $(ConvertTo-SecureString -String $TenantAdminPasswordPlain -AsPlainText -Force) -isServicePrincipal $True -aadTenantId $AADTenantId -userLogoffDelayInMinutes $UserLogoffDelayInMinutes


# Param which is missing when compared to full new hostpool: -defaultDesktopUsers $DefaultUsers   