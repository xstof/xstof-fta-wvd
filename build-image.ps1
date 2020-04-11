[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string]$ImageResourceGroup="xstof-wvd-managed-image",

  [Parameter(Mandatory=$False)]
  [string]$ImageName="xstof-wvd-session-host"
)

packer build                                               `
    -var "wvdimage_resourcegroup_name=$ImageResourceGroup" `
    -var "wvdimage_name=$ImageName"                        `
    -force                                                 `
    .\wvd-image-creation\sessionhost.json