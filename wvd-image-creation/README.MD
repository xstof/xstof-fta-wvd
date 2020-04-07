# Working with Packer

Also see: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer

## Installing Packer and dependencies

### Install Packer 
https://packer.io/downloads.html

### Install the Windows Update Provisioner
https://github.com/rgl/packer-provisioner-windows-update/releases

Put the executable in the same location as your `packer.exe`


## Create Packer Script

See example of script: [`./sessionhost.json`](./sessionhost.json)

This script assumes the presence of an Azure Files share with the artifacts it needs.  In our case, the FSLogix agent artifacts are stored on this fileshare, as follows:

![packer file share with artifacts](./images/wvd-build-image-fileshare-with-artifacts-for-packer.png)

As the example script is in flux, _only_ the following two variables are actually being used: `wvdbuildartifacts_path`, `wvdbuildartifacts_storageaccountkey`.

## Execute Packer and create image:

~~~powershell
# set environment variables
$env:wvdbuildartifactspath = "\\xstofwvdbuildartifacts.file.core.windows.net\wvdbuildartifacts"
$env:wvdbuildartifactskey = "m3aADPBLnMZ6P3vQJPjy6P...DTo2Gvhu40DjDvwg=="

# execute packer
packer build -force .\sessionhost.json
~~~

