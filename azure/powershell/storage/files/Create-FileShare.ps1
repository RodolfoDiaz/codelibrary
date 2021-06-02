# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Files (https://docs.microsoft.com/en-us/azure/storage/files/)

# Azure Files offers fully managed cross-platform file shares in the cloud that are 
# accessible via the Server Message Block (SMB) protocol.
# Quickstart: https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-powershell

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a storage account.
# 4- Get the storage account connection string.
# 5- Create an Azure file share.
# 6- Create a directory and upload a file.
# 7- Download a file.

# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount -UseDeviceAuthentication
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.Web", "Microsoft.Storage") | ForEach-Object {
  Register-AzResourceProvider -ProviderNamespace $_
}


# --------------- 2 --------------- 
Write-Host "---> Creating resource group" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/module/az.resources/
$rndResourceGroup = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
$paramResourceGroup = "rg-testapp1-shared-$rndResourceGroup"
$paramLocation = "westus"
$paramTags = @{Environment = "Test"; Department = "IT" }

$resourceGroup = Get-AzResourceGroup -Name "$paramResourceGroup" -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
  # Create new Resource Group - Get-Help New-AzResourceGroup -Online
  $resourceGroup = New-AzResourceGroup -Name "$paramResourceGroup" -Location "$paramLocation" -Tag $paramTags
}
Write-Host "---> Resource Group details:" -ForegroundColor Green
$resourceGroup


# --------------- 3 --------------- 
Write-Host "---> Creating a storage account" -ForegroundColor Green
# We need a storage account for the deployed code to live in. Storage accounts also
# need a globally unique name, so we"ll take the first section of a GUID and append it 
# to the storage account name. That should be suitable to make it globally unique.
$rndAcct = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
$storageAccountName = "stappdata$rndAcct"
$paramStorageSku = "Standard_LRS"  # https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
$paramStorageKind = "StorageV2"     # https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
$newStorageParams = @{
  ResourceGroupName = $paramResourceGroup
  AccountName       = $storageAccountName
  Location          = $paramLocation
  SkuName           = $paramStorageSku
  Tag               = $paramTags
  Kind              = $paramStorageKind
}
# Create new Storage Account - Get-Help New-AzStorageAccount -Online
$storageAccount = New-AzStorageAccount @newStorageParams
Write-Host "---> Storage Account details:" -ForegroundColor Green
$storageAccount


# --------------- 4 --------------- 
Write-Host "---> Get storage account key and connection string" -ForegroundColor Green
$storageAccountKey = Get-AzStorageAccountKey -ResourceGroupName "$paramResourceGroup" -AccountName "$storageAccountName" |
Where-Object { $_.KeyName -eq "Key1" } | Select-Object -ExpandProperty Value
$env:AZURE_STORAGE_CONNECTION_STRING = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
# Get endpoint suffix using Get-AzEnvironment: Get-AzEnvironment | select Name, StorageEndpointSuffix
$env:AZURE_STORAGE_CONNECTION_STRING = "DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=$storageAccountKey;EndpointSuffix=core.windows.net"
$env:AZURE_STORAGE_CONNECTION_STRING

# --------------- 5 --------------- 
Write-Host "---> Create an Azure file share" -ForegroundColor Green

$shareName = "myshare"
New-AzStorageShare `
    -Context $storageAccount.Context `
    -Name "$shareName" 


# --------------- 6 --------------- 
Write-Host "---> Create a directory and upload a file" -ForegroundColor Green

$directoryName="myDirectory"
New-AzStorageDirectory `
   -Context $storageAccount.Context `
   -ShareName "$shareName" `
   -Path "$directoryName"

# This expression will put the current date and time into a new file on your scratch drive
$sourceFileName="SampleUpload.txt"
Get-Date | Out-File -FilePath "$sourceFileName" -Force

# this expression will upload that newly created file to your Azure file share
Set-AzStorageFileContent `
   -Context $storageAccount.Context `
   -ShareName "$shareName" `
   -Source "$sourceFileName" `
   -Path "$directoryName\$sourceFileName"


# --------------- 8 --------------- 
Write-Host "---> Download a file" -ForegroundColor Green
# Delete an existing file by the same name as SampleDownload.txt, if it exists because you've run this example before.
Remove-Item `
    -Path "$sourceFileName" `
    -Force `
    -ErrorAction SilentlyContinue

Write-Host "---> File $sourceFileName removed." -ForegroundColor Magenta

Get-AzStorageFileContent `
    -Context $storageAccount.Context `
    -ShareName $shareName `
    -Path "$directoryName\$sourceFileName" `
    -Destination "$sourceFileName"

Write-Host "---> File $sourceFileName downloaded!" -ForegroundColor Magenta

# Cleanup 
# Remove Resource Group - Get-Help Remove-AzResourceGroup -Online
# Get-AzResourceGroup -Name $paramResourceGroup | Remove-AzResourceGroup -Force
