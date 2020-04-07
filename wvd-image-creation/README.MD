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


## Execute Packer and create image:

~~~powershell
# set environment variables
$env:wvdbuildartifactspath = "\\xstofwvdbuildartifacts.file.core.windows.net\wvdbuildartifacts"
$env:wvdbuildartifactskey = "m3aADPBLnMZ6P3vQJPjy6P...DTo2Gvhu40DjDvwg=="

# execute packer
packer build -force .\sessionhost.json
~~~

