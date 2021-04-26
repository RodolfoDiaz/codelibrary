# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Queue Storage - https://docs.microsoft.com/en-us/azure/storage/queues/

# Azure Queue Storage works in a Producer - Consumer model.
# Queues are responsible for providing data from producers to consumers and hold the data we put until it is consumed.

# Azure Queue Storage is a service for storing large numbers of messages. You access messages from anywhere 
# in the world via authenticated calls using HTTP or HTTPS. A single message can be up to 64 KiB in size (not KB).
# Messages exist within a single queue. Storage Queue requires an Azure Storage account general-purpose v2.
# The number of messages is limited only by the size of the storage account, but a single queue cannot exceed 500 TiB (not TB).
# Supports a configurable time-to-live per message (with the default at 7 days). A storage account can support 
# 20000 messages per second (assuming 1 KiB message). A single queue can support 2000 messages per second (1 KiB message).

# Queue service REST API
# https://docs.microsoft.com/en-us/rest/api/storageservices/queue-service-rest-api

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a storage account.
# 4- Get the storage account connection string.
# 5- Create a queue and show items
# 6- Create the application


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
$paramResourceGroup = "rg-testappname-shared-$rndResourceGroup"
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
$paramStorageAccount = "stappdata$rndAcct"
$paramStorageSku = "Standard_LRS"  # https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
$paramStorageKind = "StorageV2"     # https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
$newStorageParams = @{
  ResourceGroupName = $paramResourceGroup
  AccountName       = $paramStorageAccount
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
$accountKey = Get-AzStorageAccountKey -ResourceGroupName "$paramResourceGroup" -AccountName "$paramStorageAccount" |
Where-Object { $_.KeyName -eq "Key1" } | Select-Object -ExpandProperty Value
$env:storageConnectionString = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
# Get endpoint suffix using Get-AzEnvironment: Get-AzEnvironment | select Name, StorageEndpointSuffix
$env:storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$paramStorageAccount;AccountKey=$accountKey;EndpointSuffix=core.windows.net"
$env:storageConnectionString


# --------------- 5 --------------- 
Write-Host "---> Create a queue and show items" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/storage/queues/storage-powershell-how-to-use-queues
$ctx = $storageAccount.Context
$queueName = "howtoqueue"
$queue = New-AzStorageQueue –Name $queueName -Context $ctx
# Retrieve a specific queue
$queue = Get-AzStorageQueue –Name $queueName –Context $ctx
# Show the properties of the queue
$queue
# Retrieve all queues and show their names
Get-AzStorageQueue -Context $ctx | Select-Object Name
# Delete the queue
# Remove-AzStorageQueue –Name $queueName –Context $ctx -Force


# --------------- 6 --------------- 
Write-Host "---> Create the application" -ForegroundColor Green
# $azureQueueClientLibrary = "V11" # https://docs.microsoft.com/en-us/azure/storage/queues/storage-quickstart-queues-dotnet-legacy
$azureQueueClientLibrary = "V12" # https://docs.microsoft.com/en-us/azure/storage/queues/storage-quickstart-queues-dotnet
$appFolderName = "QueueApp$azureQueueClientLibrary"
$appProgramFile = "Program$azureQueueClientLibrary.cs"
if ( Test-Path -Path $appFolderName -PathType Container ) { Remove-Item -path $appFolderName -Recurse –force }
dotnet new console -n $appFolderName
Set-Location $appFolderName
if ($azureQueueClientLibrary -eq "V11") {
  dotnet add package WindowsAzure.Storage
}
if ($azureQueueClientLibrary -eq "V12") {
  dotnet add package Azure.Storage.Queues
}
Copy-Item ../$appProgramFile .
Move-Item $appProgramFile Program.cs -Force

# C#'s async and await keywords were not valid keywords in Main methods until C# 7.1. 
# In older dotnet versions (.Net Core 3.x), you may have to add the following:
# <LangVersion>7.1</LangVersion> into the PropertyGroup section in the .csproj file.

dotnet build
Write-Host "---> Check your results" -ForegroundColor Green
if ($azureQueueClientLibrary -eq "V11") {
  dotnet run This is the first message!
  dotnet run This is the second message!
  dotnet run
  dotnet run
}
if ($azureQueueClientLibrary -eq "V12") {
  dotnet run
}
Set-Location ..
