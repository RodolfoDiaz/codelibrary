# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Event Hubs - https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-quickstart-powershell

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create an Event Hubs namespace namespace.
# 4- Create an event hub in the namespace you created.
# 5- Get the primary connection string for the namespace.
# 6- Create an application to Send events.
# 7- Create a storage account.
# 8- Get the storage account connection string.
# 9- Create a blob container.
# 10- Create an application to Receive events.


# The following commands are available in PowerShell:
# Get-Command -Module Az.EventHub

# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# Most likely, the providers are already registered, but this will make sure of that.
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
Write-Host "---> Creating an Event Hubs namespace" -ForegroundColor Green
$rndehns = (New-Guid).ToString().Split("-")[0]
# Namespace naming rules: length 6-50, Alphanumerics and hyphens.
$paramEventHubNamespace = "test-eventhubsnamespace-$rndehns"
$paramNamespaceSku = "Basic"  # Event Hubs comes in Basic, Standard, and Dedicated tiers. https://azure.microsoft.com/en-us/pricing/details/event-hubs/
$eventHubNamespace = New-AzEventHubNamespace -ResourceGroupName "$paramResourceGroup" -Name "$paramEventHubNamespace" -Location "$paramLocation" -SkuName $paramNamespaceSku -Tag $paramTags
Write-Host "---> Event Hub Namespace details:" -ForegroundColor Green
$eventHubNamespace


# --------------- 4 --------------- 
Write-Host "---> Creating an event hub in the namespace you created" -ForegroundColor Green
$rndeventhub = (New-Guid).ToString().Split("-")[0]
$env:eventhubName = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:eventhubName = "test_eventhub_$rndeventhub"
$retentionInDays = 1  # Message Retention customization is not available in a Basic Tier Namespace. Change variable $paramNamespaceSku to "Standard" to increase message retention.
$eventhub = New-AzEventHub -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramEventHubNamespace" -Name "$env:eventhubName" -MessageRetentionInDays $retentionInDays
Write-Host "---> Event Hub details:" -ForegroundColor Green
$eventhub


# --------------- 5 --------------- 
Write-Host "---> Get the primary connection string for the namespace" -ForegroundColor Green
$eventhubKey = Get-AzEventHubKey -ResourceGroupName "$paramResourceGroup" -Namespace "$paramEventHubNamespace" -Name "RootManageSharedAccessKey"
$eventhubKey
$env:ehubNamespaceConnectionString = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:ehubNamespaceConnectionString = $eventhubKey.PrimaryConnectionString
Write-Host "---> Primary Connection String" -ForegroundColor Green
$env:ehubNamespaceConnectionString


# --------------- 6 --------------- 
Write-Host "---> Create an application to Send events" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-dotnet-standard-getstarted-send
$appFolderName = "EventHubsAppSend"
$appProgramFile = "ProgramEH-Send.cs"
if ( Test-Path -Path $appFolderName -PathType Container ) { Remove-Item -path $appFolderName -Recurse –force }
dotnet new console -n $appFolderName
Set-Location $appFolderName
dotnet add package Azure.Messaging.EventHubs
Copy-Item ../$appProgramFile .
Move-Item $appProgramFile Program.cs -Force
Write-Host "---> Check your results" -ForegroundColor Green
dotnet build
# NOTE: If you receive a Timeout Exception, your environment is probably blocking the TCP ports
# used for AMQP by default. You need to have ports 5671 and 5672 opened for AMQP connections.
dotnet run
Write-Host "---> In the Azure portal, you can verify that the event hub has received the messages. Switch to Messages view in the Metrics section." -ForegroundColor Green
Set-Location ..


# --------------- 7 --------------- 
Write-Host "---> Creating a storage account" -ForegroundColor Green
# We need a storage account for the deployed code to live in. Storage accounts also
# need a globally unique name, so we"ll take the first section of a GUID and append it 
# to the storage account name. That should be suitable to make it globally unique.
$rndAcct = (New-Guid).ToString().Split("-")[0]
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
$paramStorageAccount = "teststorage$rndAcct"
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


# --------------- 8 --------------- 
Write-Host "---> Get storage account key and connection string" -ForegroundColor Green
$accountKey = Get-AzStorageAccountKey -ResourceGroupName "$paramResourceGroup" -AccountName "$paramStorageAccount" |
Where-Object { $_.KeyName -eq "Key1" } | Select-Object -ExpandProperty Value
$env:storageConnectionString = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$paramStorageAccount;AccountKey=$accountKey"
$env:storageConnectionString


# --------------- 9 --------------- 
Write-Host "---> Create a blob container" -ForegroundColor Green
$ctx = $storageAccount.Context
$env:containerName = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:containerName = "messages"
New-AzStorageContainer -Name "$env:containerName" -Context $ctx -Permission "Blob"


# --------------- 10 --------------- 
Write-Host "---> Create an application to Receive events" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-dotnet-standard-getstarted-send
$appFolderName = "EventHubsAppReceive"
$appProgramFile = "ProgramEH-Receive.cs"
if ( Test-Path -Path $appFolderName -PathType Container ) { Remove-Item -path $appFolderName -Recurse –force }
dotnet new console -n $appFolderName
Set-Location $appFolderName
dotnet add package Azure.Messaging.EventHubs
dotnet add package Azure.Messaging.EventHubs.Processor
Copy-Item ../$appProgramFile .
Move-Item $appProgramFile Program.cs -Force
Write-Host "---> Check your results" -ForegroundColor Green
dotnet build
# NOTE: If you receive a Timeout Exception, your environment is probably blocking the TCP ports
# used for AMQP by default. You need to have ports 5671 and 5672 opened for AMQP connections.
dotnet run
Set-Location ..
