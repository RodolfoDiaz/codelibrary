# Azure Functions - https://azure.microsoft.com/en-us/services/functions/

# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
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
$paramResourceGroup = "mytest-func-demo"
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
# Azure Functions need a storage account for the deployed code to live in. Storage accounts 
# also need a globally unique name, so we"ll take the first section of a GUID and append it 
# to the storage account name. That should be suitable to make it globally unique.
$rndAcct = (New-Guid).ToString().Split("-")[0]
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
$paramStorageAccount = "mytest$rndAcct"
$paramStorageSku = "Standard_LRS"  # https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
$newStorageParams = @{
  ResourceGroupName = $paramResourceGroup
  AccountName       = $paramStorageAccount
  Location          = $paramLocation
  SkuName           = $paramStorageSku
  Tag               = $paramTags
}
# Create new Storage Account - Get-Help New-AzStorageAccount -Online
$storageAccount = New-AzStorageAccount @newStorageParams
Write-Host "---> Storage Account details:" -ForegroundColor Green
$storageAccount


# --------------- 4 --------------- 
# Get storage account key and create connection string
$accountKey = Get-AzStorageAccountKey -ResourceGroupName "$paramResourceGroup" -AccountName "$paramStorageAccount" |
Where-Object { $_.KeyName -eq "Key1" } | Select-Object -ExpandProperty Value
$storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$paramStorageAccount;AccountKey=$accountKey"


# --------------- 5 --------------- 
Write-Host "---> Create a Function App" -ForegroundColor Green
# Create the Function App
$rndFunc = (New-Guid).ToString().Split("-")[0]
$paramFunctionApp = "mytestFunc-$rndFunc"
$paramFunctionAppVersion = "3"
# Set the OS type for the app to be created. accepted values: Linux, Windows
$paramFunctionAppOS = "Linux"
# Set the runtime language - https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings
# Valid values are: dotnet (C#/F#), node (JavaScript/TypeScript), java (Java), powershell (PowerShell), and python (Python).
$functionAppRuntimeStack = "python"
# The version of the functions runtime stack. 
# Allowed values for each --runtime are: node -> [8, 10, 12, 14 (preview)], java -> [8, 11], powershell -> [7.0], python -> [3.6, 3.7, 3.8].
$functionRuntimeVersion = "3.8"
$functionApp = New-AzFunctionApp -Location "$paramLocation" -Name "$paramFunctionApp" -ResourceGroupName "$paramResourceGroup" -StorageAccountName "$paramStorageAccount" -OSType "$paramFunctionAppOS" -FunctionsVersion "$paramFunctionAppVersion" -Runtime "$functionAppRuntimeStack" -RuntimeVersion "$functionRuntimeVersion" -Tag $paramTags
Write-Host "---> Function App details:" -ForegroundColor Green
$functionApp
# Set the function name
$functionName = "HelloWorld-Python"


# --------------- 6 --------------- 
Write-Host "---> Configure Function App settings" -ForegroundColor Green
Update-AzFunctionAppSetting -Name $paramFunctionApp -ResourceGroupName "$paramResourceGroup" -AppSetting @{"AzureWebJobDashboard" = "$storageConnectionString" } -Force
Update-AzFunctionAppSetting -Name $paramFunctionApp -ResourceGroupName "$paramResourceGroup" -AppSetting @{"AzureWebJobsStorage" = "$storageConnectionString" } -Force
Update-AzFunctionAppSetting -Name $paramFunctionApp -ResourceGroupName "$paramResourceGroup" -AppSetting @{"AzureWebJobsSecretStorageType" = "Files" } -Force


# --------------- 7 --------------- 
Write-Host "---> Deploy the function" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-powershell?tabs=azure-powershell
# https://docs.microsoft.com/en-us/azure/azure-functions/deployment-zip-push
$publishZip = "$functionName.zip"
if ( Test-Path -Path $publishZip -PathType Leaf ) { Remove-Item -path $publishZip -Recurse –force }
Compress-Archive -Path $functionName -DestinationPath .\$publishZip
$publishItem = Publish-AzWebApp -ResourceGroupName "$paramResourceGroup" -Name "$paramFunctionApp" -ArchivePath  (Get-Item $publishZip).FullName -Force
Write-Host "---> Function published:" -ForegroundColor Green
$publishItem


# --------------- 8 --------------- 
Write-Host "---> Test the function" -ForegroundColor Green
# Test function
$functionAppId = $functionApp.Id
$functionAppHostName = $functionApp.DefaultHostName
$masterKey = (Invoke-AzResourceAction -ResourceId "$functionAppId/functions/$functionName" -Action listkeys -Force).default
$invokeUrl = "https://" + $functionAppHostName + "/api/" + $functionName + "?code=" + $masterKey

Write-Warning $invokeUrl

Write-Host "--->  Using GET method" -ForegroundColor Green
Invoke-RestMethod -Uri "$($invokeUrl)&name=World"
 
Write-Host "--->  Using POST method" -ForegroundColor Green
$body = @{ "name" = "World with POST" } | ConvertTo-Json
Invoke-WebRequest -Uri $invokeUrl -Body $body -Method Post -ContentType "application/json"

# Open URL in default browser
Start-Process "$($invokeUrl)&name=World"

# Test with cURL
# Caution: If you are on Windows, please run cURL from the command prompt. 
# PowerShell has a curl command, but it's an alias for Invoke-WebRequest and is not the same as cURL.
# curl --header "Content-Type: application/json" --header "x-functions-key: <your-function-key>" --request POST --data "{\"name\": \"Azure Function\"}" https://<your-url-here>/api/HelloWorld


# Cleanup 
# Remove Resource Group - Get-Help Remove-AzResourceGroup -Online
# Get-AzResourceGroup -Name $paramResourceGroup | Remove-AzResourceGroup -Force
