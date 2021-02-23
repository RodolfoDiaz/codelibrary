# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Event Grid - https://docs.microsoft.com/en-us/azure/event-grid/

# Route storage events to web endpoint with PowerShell
# https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-event-quickstart-powershell

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a storage account.
# 4- Get the storage account connection string.
# 5- Create a message endpoint.
# 6- Subscribe to your storage account.
# 7- Trigger an event from Blob storage.


# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.EventGrid", "Microsoft.Storage") | ForEach-Object {
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


# --------------- 4 --------------- 
Write-Host "---> Get storage account key and connection string" -ForegroundColor Green
$accountKey = Get-AzStorageAccountKey -ResourceGroupName "$paramResourceGroup" -AccountName "$paramStorageAccount" |
Where-Object { $_.KeyName -eq "Key1" } | Select-Object -ExpandProperty Value
# Get endpoint suffix using Get-AzEnvironment: Get-AzEnvironment | select Name, StorageEndpointSuffix
$storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$paramStorageAccount;AccountKey=$accountKey;EndpointSuffix=core.windows.net"
$storageConnectionString


# --------------- 5 --------------- 
Write-Host "---> Create a message endpoint" -ForegroundColor Green
$rndSite = (New-Guid).ToString().Split("-")[0]
$sitename = "test-website-$rndSite"

$resourceGroupDeployment = New-AzResourceGroupDeployment `
  -ResourceGroupName "$paramResourceGroup" `
  -TemplateUri "https://raw.githubusercontent.com/Azure-Samples/azure-event-grid-viewer/master/azuredeploy.json" `
  -siteName "$sitename" `
  -hostingPlanName "viewerhost"

Write-Host "---> Resource Group Deployment details:" -ForegroundColor Green
$resourceGroupDeployment

Write-Host "---> After the deployment has succeeded, view your web app to make sure it's running." -ForegroundColor Green
# Open URL in default browser
Start-Process "https://$($sitename).azurewebsites.net"


# --------------- 6 --------------- 
Write-Host "---> Subscribe to your storage account" -ForegroundColor Green
$storageId = $storageAccount.Id
$endpoint = "https://$sitename.azurewebsites.net/api/updates"
$eventSubscriptionName = "gridBlobTest"

$eventGridSubscription = New-AzEventGridSubscription `
  -EventSubscriptionName "$eventSubscriptionName" `
  -Endpoint "$endpoint" `
  -ResourceId "$storageId"

Write-Host "---> Event Grid Subscription details:" -ForegroundColor Green
$eventGridSubscription


# --------------- 7 --------------- 
Write-Host "---> Trigger an event from Blob storage" -ForegroundColor Green
$rndContainer = (New-Guid).ToString().Split("-")[0]
$containerName = "gridcontainer-$rndContainer"
$ctx = $storageAccount.Context
$storageContainer = New-AzStorageContainer -Name "$containerName" -Context $ctx
Write-Host "---> Storage Container details:" -ForegroundColor Green
$storageContainer
Write-Output "This is a test file!" >> gridTestFile.txt
$storageBlobContent = Set-AzStorageBlobContent -File gridTestFile.txt -Container "$containerName" -Context $ctx -Blob gridTestFile.txt
Write-Host "---> Storage Blob Content details:" -ForegroundColor Green
$storageBlobContent
