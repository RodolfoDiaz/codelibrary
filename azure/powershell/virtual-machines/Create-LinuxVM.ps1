# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Virtual Machines - https://docs.microsoft.com/en-us/azure/virtual-machines/
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-powershell

# The deployment process is:
# 1- Use ssh-keygen to create an SSH key pair.
# 2- Log in to Azure.
# 3- Create a resource group.
# 4- Create virtual network resources.
# 5- Create a virtual machine.
# 6- Connect to the VM.


# --------------- 1 --------------- 
Write-Host "---> Use ssh-keygen to create an SSH key pair." -ForegroundColor Green
# An SSH key consists of a pair of files. One is the private key, which should never 
# be shared with anyone. The other is the public key. The other file is a public key 
# which allows you to log into the containers and VMs you provision. When you generate 
# the keys, you will use ssh-keygen to store the keys in a safe location so you can bypass 
# the login prompt when connecting to your instances.
if (-not (Test-Path ~\.ssh\id_rsa.pub -PathType Leaf)) {
  # https://www.ssh.com/ssh/keygen/
  ssh-keygen -m PEM -t rsa -b 4096
} 


# --------------- 2 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount -UseDeviceAuthentication
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.Compute", "Microsoft.Storage", "Microsoft.Network") | ForEach-Object {
  Register-AzResourceProvider -ProviderNamespace $_
}


# --------------- 3 --------------- 
Write-Host "---> Creating resource group" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/module/az.resources/
$rndResourceGroup = (New-Guid).ToString().Split("-")[0]
$paramResourceGroup = "test_resourcegroup_$rndResourceGroup"
$paramLocation = "westus"
$paramTags = @{Environment = "Test"; Department = "IT" }

$resourceGroup = Get-AzResourceGroup -Name "$paramResourceGroup" -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
  # Create new Resource Group - Get-Help New-AzResourceGroup -Online
  $resourceGroup = New-AzResourceGroup -Name "$paramResourceGroup" -Location "$paramLocation" -Tag $paramTags
}
Write-Host "---> Resource Group details:" -ForegroundColor Green
$resourceGroup


# --------------- 4 --------------- 
Write-Host "---> Create virtual network resources" -ForegroundColor Green
# When you set up a virtual network, you specify the available address spaces, subnets, and security. 
# If the VNet will be connected to other VNets, you must select address ranges that are not overlapping. 
# This is the range of private addresses that the VMs and services in your network can use. 
# You can use unroutable IP addresses such as 10.0.0.0/8, 172.16.0.0/12, or 192.168.0.0/16, or define your own range.

# Create a subnet configuration
# Segregate your network: you might assign 10.1.0.0 to VMs, 10.2.0.0 to back-end services, and 10.3.0.0 to SQL Server VMs.
$paramNetworkSubnetConfig = "mySubnet"
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name "$paramNetworkSubnetConfig" `
  -AddressPrefix 192.168.1.0/24

# Create a virtual network
$paramVirtualNetwork = "myVNET"
$paramAddressPrefix = "192.168.0.0/16"
$vnet = New-AzVirtualNetwork `
  -ResourceGroupName "$paramResourceGroup" `
  -Location "$paramLocation" `
  -Name "$paramVirtualNetwork" `
  -AddressPrefix "$paramAddressPrefix" `
  -Subnet $subnetConfig `
  -Tag $paramTags

# Create a public IP address and specify a DNS name
$paramPublicIpAddress = "myPublicIP-$(Get-Random)"
$pip = New-AzPublicIpAddress `
  -ResourceGroupName "$paramResourceGroup" `
  -Location "$paramLocation" `
  -AllocationMethod Static `
  -IdleTimeoutInMinutes 4 `
  -Name "$paramPublicIpAddress" `
  -Tag $paramTags

# Create an inbound network security group rule for port 22 (SSH)
$paramNSGRule1 = "testNetworkSecurityGroupRuleSSH"
$nsgRuleSSH = New-AzNetworkSecurityRuleConfig `
  -Name "$paramNSGRule1"  `
  -Protocol "Tcp" `
  -Direction "Inbound" `
  -Priority 1000 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 22 `
  -Access "Allow"

# Create an inbound network security group rule for port 80 (Web)
$paramNSGRule2 = "testNetworkSecurityGroupRuleWWW"
$nsgRuleWeb = New-AzNetworkSecurityRuleConfig `
  -Name "$paramNSGRule2"  `
  -Protocol "Tcp" `
  -Direction "Inbound" `
  -Priority 1001 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 80 `
  -Access "Allow"

# Create a network security group
$paramNetworkSecurityGroup = "myNetworkSecurityGroup"
$nsg = New-AzNetworkSecurityGroup `
  -ResourceGroupName "$paramResourceGroup" `
  -Location "$paramLocation" `
  -Name "$paramNetworkSecurityGroup" `
  -SecurityRules $nsgRuleSSH, $nsgRuleWeb `
  -Tag $paramTags

# Create a virtual network card and associate with public IP address and NSG
$paramNetworkInterface = "testNic"
$nic = New-AzNetworkInterface `
  -Name "$paramNetworkInterface" `
  -ResourceGroupName "$paramResourceGroup" `
  -Location "$paramLocation" `
  -SubnetId $vnet.Subnets[0].Id `
  -PublicIpAddressId $pip.Id `
  -NetworkSecurityGroupId $nsg.Id `
  -Tag $paramTags

Write-Host "---> Network Interface details:" -ForegroundColor Green
$nic


# --------------- 5 --------------- 
Write-Host "---> Create a virtual machine" -ForegroundColor Green

$paramVMusername = "azureuser"
$paramVMPassword = "ChangeThisPassword@123"
$rndVM = (New-Guid).ToString().Split("-")[0]
$paramVirtualMachine = "testVM-$rndVM" # Linux VM names may only contain letters, numbers, '.', and '-'.
# https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs
$paramVMSize = "Standard_D1_v2" # Available sizes:  Get-AzComputeResourceSku | where {$_.Locations -icontains "$paramLocation"}

# Define a credential object
$securePassword = ConvertTo-SecureString "$paramVMPassword" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("$paramVMusername", $securePassword)

# Create a virtual machine configuration
# Available source images: Get-AzVMImageSku -Location "westus" -PublisherName "Canonical" -Offer "UbuntuServer"
$paramPublisher = "Canonical"
$paramOffer = "UbuntuServer"
$paramSkus = "18.04-LTS"
$paramVersion = "latest"

$vmConfig = New-AzVMConfig `
  -VMName "$paramVirtualMachine" `
  -VMSize $paramVMSize | `
  Set-AzVMOperatingSystem `
  -Linux `
  -ComputerName "$paramVirtualMachine" `
  -Credential $cred `
  -DisablePasswordAuthentication | `
  Set-AzVMSourceImage `
  -PublisherName "$paramPublisher" `
  -Offer "$paramOffer" `
  -Skus "$paramSkus" `
  -Version "$paramVersion" | `
  Add-AzVMNetworkInterface `
  -Id $nic.Id

# Configure the SSH key
$sshPublicKey = Get-Content ~/.ssh/id_rsa.pub
Add-AzVMSshPublicKey `
  -VM $vmconfig `
  -KeyData $sshPublicKey `
  -Path "/home/$paramVMusername/.ssh/authorized_keys"

# Combine the previous configuration definitions to create the virtual machine
$myVM = New-AzVM `
  -ResourceGroupName "$paramResourceGroup" `
  -Location "$paramLocation" `
  -VM $vmConfig `
  -Tag $paramTags
Write-Host "---> Virtual Machine $paramVirtualMachine status:" -ForegroundColor Green
$myVM


# --------------- 6 --------------- 
Write-Host "---> Connect to the VM" -ForegroundColor Green
Write-Host "---> Username is: $paramVMusername"
Write-Host "---> Public IP address is: "
Get-AzPublicIpAddress -Name "$paramPublicIpAddress" | Select-Object "IpAddress"
Write-Host "---> Enter the following command: ssh $paramVMusername@IpAddress"
