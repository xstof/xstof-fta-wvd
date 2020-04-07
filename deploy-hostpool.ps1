[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string]$RGName="xstof-wvd-hostpool",

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
  [string]$OUToJoin = "OU=WVDSessionHosts,DC=XSTOF,DC=XYZ",

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

  [Parameter(Mandatory=$False)]
  [string]$DefaultUsers="liss@xstof.xyz,timo@xstof.xyz",

  [Parameter(Mandatory=$False)]
  [string]$TenantAdminAppId="43b2ddf9-7a61-47ec-b43b-a445b26d83c9",

  [Parameter(Mandatory=$True)]
  [string]$TenantAdminPasswordPlain,

  [Parameter(Mandatory=$False)]
  [string]$AADTenantId="3fd11e85-d8ce-4c7f-b6a0-816346615777"
)


New-AzResourceGroupDeployment -Name "WVD-Hostpool-Deployment" -ResourceGroupName $RGName -TemplateFile ./templates/hostpool.json -rdshImageSource "Gallery" -rdshGalleryImageSKU "Windows-10-Enterprise-multi-session-with-Office-365-ProPlus" -rdshNamePrefix $HostPoolVMPrefix -rdshNumberOfInstances $NrHostInstances -rdshVMDiskType "StandardSSD_LRS" -rdshVmSize "Standard_D2s_v3" -domainToJoin $DomainToJoin -existingDomainUPN $DomainJoinerUPN -existingDomainPassword $(ConvertTo-SecureString -String $DomainJoinerPasswordPlain -AsPlainText -Force) -ouPath $OUToJoin -existingVnetName $VNetToJoin -newOrExistingVnet "existing" -existingSubnetName $SubNetToJoin -virtualNetworkResourceGroupName $VNetToJoinResourceGroup -existingTenantName $WvdTenantName -hostPoolName $HostPoolName -enablePersistentDesktop $False -defaultDesktopUsers $DefaultUsers -tenantAdminUpnOrApplicationId $TenantAdminAppId -tenantAdminPassword $(ConvertTo-SecureString -String $TenantAdminPasswordPlain -AsPlainText -Force) -isServicePrincipal $True -aadTenantId $AADTenantId