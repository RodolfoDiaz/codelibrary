# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Blob Storage - https://docs.microsoft.com/en-us/azure/storage/blobs/

# A binary large object (blob) is concentrated binary data that's compressed into an individual 
# file inside a database. The large size of the file means they need special storage treatment. 
# Blobs are binary, which means they are usually images, audio or other media.

# Blob service REST API
# https://docs.microsoft.com/en-us/rest/api/storageservices/blob-service-rest-api

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a storage account.
# 4- Get the storage account connection string.
# 5- Create a blob container and upload file.
# 6- Create the application

# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.Web", "Microsoft.Storage") | ForEach-Object {
  Register-AzResourceProvider -ProviderNamespace $_
}


# --------------- 2 --------------- 
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


# --------------- 3 --------------- 
Write-Host "---> Creating a storage account" -ForegroundColor Green
# We need a storage account for the deployed code to live in. Storage accounts also
# need a globally unique name, so we"ll take the first section of a GUID and append it 
# to the storage account name. That should be suitable to make it globally unique.
$rndAcct = (New-Guid).ToString().Split("-")[0]
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
$AZURE_STORAGE_ACCOUNT = "teststorage$rndAcct"
$paramStorageSku = "Standard_LRS"  # https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
$paramStorageKind = "StorageV2"     # https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
$newStorageParams = @{
  ResourceGroupName = $paramResourceGroup
  AccountName       = $AZURE_STORAGE_ACCOUNT
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
$AZURE_STORAGE_KEY = Get-AzStorageAccountKey -ResourceGroupName "$paramResourceGroup" -AccountName "$AZURE_STORAGE_ACCOUNT" |
Where-Object { $_.KeyName -eq "Key1" } | Select-Object -ExpandProperty Value
$env:AZURE_STORAGE_CONNECTION_STRING = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
# Get endpoint suffix using Get-AzEnvironment: Get-AzEnvironment | select Name, StorageEndpointSuffix
$env:AZURE_STORAGE_CONNECTION_STRING = "DefaultEndpointsProtocol=https;AccountName=$AZURE_STORAGE_ACCOUNT;AccountKey=$AZURE_STORAGE_KEY;EndpointSuffix=core.windows.net"
$env:AZURE_STORAGE_CONNECTION_STRING


# --------------- 5 --------------- 
Write-Host "---> Create a blob container and upload file" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-powershell
$paramContainerName = "test-image-container"
$paramFileName = "Azure-Logos.png"
$paramPublicAccess = "off" # By default, container data is private ("off") to the account owner. Use "blob" to allow public read access for blobs. Use "container" to allow public read and list access to the entire container.
$ctx = $storageAccount.Context
$storageContainer = New-AzStorageContainer -Name "$paramContainerName" -Context $ctx -Permission "$paramPublicAccess"
$storageContainer
$paramStandardBlobTier = "Cool"  # Block Blob Tier, valid values are Hot/Cool/Archive. https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-storage-tiers
$paramBlobName = "FolderA/FolderB/FolderC/$paramFileName" # Blob name prefixes (virtual directories)
Set-AzStorageBlobContent -File "$paramFileName" `
  -Container "$paramContainerName" `
  -Blob "$paramBlobName" `
  -Context $ctx `
  -StandardBlobTier "$paramStandardBlobTier"
Write-Host "---> File uploaded to the blob container $paramContainerName is available online with a SAS token." -ForegroundColor Green
#$blobUrl = "https://$AZURE_STORAGE_ACCOUNT.blob.core.windows.net/$paramContainerName/$paramBlobName"
$startTime = Get-Date
# Availability of the URL: Get current date/time and add 2 hours
$endTime = $startTime.AddHours(2.0)
$blobUrlToken = New-AzStorageBlobSASToken -Container "$paramContainerName" -Blob "$paramBlobName" -Permission r -StartTime "$startTime" -ExpiryTime "$endTime" -Protocol "HttpsOnly" -FullUri
Write-Host "$blobUrlToken"
Start-Process "$blobUrlToken"
Write-Host "---> List items inside the container using a hierarchical listing" -ForegroundColor Green
# Technically, containers are "flat" and do not support any kind of nesting or hierarchy. 
# But if you give your blobs hierarchical names that look like file paths, 
# the API's listing operation can filter results to specific prefixes.
# https://docs.microsoft.com/en-us/powershell/module/az.storage/get-azstorageblob
Get-AzStorageBlob -Container "$paramContainerName" -Context $ctx -Prefix "FolderA/FolderB/" | Select-Object Name


# --------------- 6 --------------- 
Write-Host "---> Create the application" -ForegroundColor Green
# $blobStorageClientLibrary = "V11" # https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-dotnet-legacy
$blobStorageClientLibrary = "V12" # https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-dotnet
$appFolderName = "BlobApp$blobStorageClientLibrary"
$appProgramFile = "Program$blobStorageClientLibrary.cs"
if ( Test-Path -Path $appFolderName -PathType Container ) { Remove-Item -path $appFolderName -Recurse –force }
dotnet new console -n $appFolderName
Set-Location $appFolderName
if ($blobStorageClientLibrary -eq "V11") {
  dotnet add package Microsoft.Azure.Storage.Blob
}
if ($blobStorageClientLibrary -eq "V12") {
  dotnet add package Azure.Storage.Blobs
}
Copy-Item ../$appProgramFile .
Move-Item $appProgramFile Program.cs -Force
New-Item -Path "." -Name "data" -ItemType "directory"
dotnet build
Write-Host "---> Check your results" -ForegroundColor Green
dotnet run
Set-Location ..
