# Building Squid Proxy using Packer

Also see: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer

## Squid config

Squid will be listening on port `3128` and allows connections from CIDR block `10.1.0.0/16`

## Build Image

~~~powershell
# execute packer
packer build -force .\squid.json
~~~

