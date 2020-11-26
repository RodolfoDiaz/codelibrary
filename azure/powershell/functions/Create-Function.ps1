# Azure Functions - https://azure.microsoft.com/en-us/services/functions/
Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"
# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a storage account.
# 4- Get the storage account connection string.
# 5- Create a function app.
# 6- Set the function app settings.
# 7- Deploy the function.
# 8- Test the function.

# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# Azure Functions require the Microsoft.Web and Microsoft.Storage providers. 
# Most likely, the providers are already registered, but this will make sure of that.
@("Microsoft.Web", "Microsoft.Storage") | ForEach-Object {
  Register-AzResourceProvider -ProviderNamespace $_
}

# --------------- 2 --------------- 
Write-Host "---> Creating resource group" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/module/az.resources/
$resourceGroupName = "mytest-func-demo"
$location = "West US"
$tag = @{Environment = "Test"; Department = "IT" }
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
  # Create new Resource Group - Get-Help New-AzResourceGroup -Online
  $resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tag
}
Write-Host "---> Resource Group details:" -ForegroundColor Green
$resourceGroup


# --------------- 3 --------------- 
Write-Host "---> Creating a storage account" -ForegroundColor Green
# Azure Functions need a storage account for the deployed code to live in. Storage accounts 
# also need a globally unique name, so we"ll take the first section of a GUID and append it 
# to the storage account name. That should be suitable to make it globally unique.
$rnd = (New-Guid).ToString().Split("-")[0]
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
$storageAccountName = "mytest$rnd"
$storageSku = "Standard_LRS"  # https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
$newStorageParams = @{
  ResourceGroupName = $resourceGroupName
  AccountName       = $storageAccountName
  Location          = $location
  SkuName           = $storageSku
  Tag               = $tag
}
# Create new Storage Account - Get-Help New-AzStorageAccount -Online
$storageAccount = New-AzStorageAccount @newStorageParams
Write-Host "---> Storage Account details:" -ForegroundColor Green
$storageAccount


# --------------- 4 --------------- 
# Get storage account key and create connection string
$accountKey = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccountName |
Where-Object { $_.KeyName -eq "Key1" } | Select-Object -ExpandProperty Value
$storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=$accountKey"


# --------------- 5 --------------- 
Write-Host "---> Create a Function App" -ForegroundColor Green
# Create the Function App
$functionAppName = "mytest-func"
$newFunctionAppParams = @{
  ResourceType      = "Microsoft.Web/Sites"
  ResourceName      = $functionAppName
  Kind              = "functionapp"
  Location          = $location
  ResourceGroupName = $resourceGroupName
  Properties        = @{}
  Force             = $true
  Tag               = $tag
}
# Create new Function App - Get-Help New-AzResource -Online
$functionApp = New-AzResource @newFunctionAppParams
Write-Host "---> Function App details:" -ForegroundColor Green
$functionApp


# --------------- 6 --------------- 
Write-Host "---> Configure Function App settings" -ForegroundColor Green
# Set Function app settings
# https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings
$functionAppSettings = @{
  AzureWebJobDashboard                     = $storageConnectionString
  AzureWebJobsStorage                      = $storageConnectionString
  #AzureWebJobsSecretStorageType            = "Files"
  FUNCTIONS_EXTENSION_VERSION              = "~1"
  WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = $storageConnectionString
  WEBSITE_CONTENTSHARE                     = $storageAccountName
}
$setWebAppParams = @{
  Name              = $functionAppName
  ResourceGroupName = $resourceGroupName
  AppSettings       = $functionAppSettings
}
# Set configuration settings - Get-Help Set-AzWebApp -Online
$webApp = Set-AzWebApp @setWebAppParams
Write-Host "---> Web App settings details:" -ForegroundColor Green
$webApp


# --------------- 7 --------------- 
Write-Host "---> Deploy the function" -ForegroundColor Green

$sourceFile = "run.ps1"
$functionName = "HelloWorld"
$functionContent = Get-Content ./HelloWorld/$sourceFile -raw
$functionSettings = Get-Content ./HelloWorld/function.json | ConvertFrom-Json
$functionResourceId = "{0}/functions/{1}" -f $functionapp.resourceid, $functionName
$functionProperties = @{
  config = @{bindings = $functionSettings.bindings
  }
  files  = @{
    "$sourceFile" = "$functionContent"
  }
}
$newFunctionParams = @{
  ResourceID = $functionResourceId
  Properties = $functionProperties
  # ApiVersion = "2020-06-01"  # Specifies the version of the resource provider API to use. If you do not specify a version, this cmdlet uses the latest available version.
  Force      = $true
}
$function = New-AzResource @NewfunctionParams
Write-Host "---> Function details:" -ForegroundColor Green
$function


# --------------- 8 --------------- 
Write-Host "---> Test the function" -ForegroundColor Green
# Test function
$getSecretsParams = @{
  ResourceId = $function.ResourceId
  Action     = 'listsecrets'
  Force      = $true
}
# Invoke an action - Get-Help Invoke-AzResourceAction -Online
$functionSecrets = Invoke-AzResourceAction @getSecretsParams

# For testing Only
# Write-Warning $functionSecrets.trigger_url

Write-Host "--->  Using GET method" -ForegroundColor Green
Invoke-RestMethod -Uri "$($functionSecrets.trigger_url)&name=World"
 
Write-Host "--->  Using POST method" -ForegroundColor Green
$body = @{
  name = 'World'
} | ConvertTo-Json
Invoke-RestMethod -Uri $functionSecrets.trigger_url -Body $body -Method Post

# Test with cURL
# Caution: If you are on Windows, please run cURL from the command prompt. 
# PowerShell has a curl command, but it's an alias for Invoke-WebRequest and is not the same as cURL.

# curl --header "Content-Type: application/json" --header "x-functions-key: <your-function-key>" --request POST --data "{\"name\": \"Azure Function\"}" https://<your-url-here>/api/HelloWorld


# Cleanup 
# Remove Resource Group - Get-Help Remove-AzResourceGroup -Online
# Get-AzResourceGroup -Name $resourceGroupName | Remove-AzResourceGroup -Force
