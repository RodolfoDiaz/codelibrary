# Using Azure Functions Core Tools
# https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local

# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

Write-Host "---> This example uses the following components: " -ForegroundColor Green
Write-Host "---> * Azure Functions Core Tools version 3.x." -ForegroundColor Green
func --version
Write-Host "---> * .NET Core SDK 3.1 or above" -ForegroundColor Green
dotnet --version

# VARIABLES 
$AppName = "mytest-func"  # New-Variable -Name "AppName" -Visibility Public -Value "mytest-func"
$functionName = "HelloWorld"  # New-Variable -Name "functionName" -Visibility Public -Value "HelloWorld"

$runtime = @{
  python = "python"
  dotnet = "dotnet"
  node   = "node"
}
$language = @{
  python = "python"
  js     = "javascript"
  ts     = "typescript"
  CS     = "C#"
}

$functionRuntime = $runtime.dotnet
$functionLanguage = $language.CS
$functionTemplate = "HttpTrigger"

# Cleanup
if ( Test-Path -Path $AppName -PathType Container ) { Remove-Item -path $AppName -Recurse –force }

New-Item -ItemType directory -Path $AppName
Set-Location -Path $AppName

Write-Host "--> Create the FunctionApp" -ForegroundColor Green
func init --worker-runtime $functionRuntime

if ($functionRuntime -eq "dotnet") {
  Write-Host "--> Restore NuGet package(s)" -ForegroundColor Green
  dotnet restore

  Write-Host "--> Check for outdated NuGet package(s)" -ForegroundColor Green
  dotnet list package --outdated

  Write-Host "--> Compile the solution" -ForegroundColor Green
  dotnet build
}

Write-Host "--> Create new function" -ForegroundColor Green
func new --language $functionLanguage --template $functionTemplate --name $functionName

if ($functionRuntime -eq "dotnet") {
  Write-Host "--> Publish the solution and prepare a ZIP archive for deployment" -ForegroundColor Green
  dotnet publish --configuration Release
  Compress-Archive -Path .\bin\Release\netcoreapp3.1\publish\* -DestinationPath .\$AppName.zip
}

Write-Host "--> Execute and test the FunctionApp locally" -ForegroundColor Green
func start --verbose

# Run the following command to start the Functions host silently in the background.
# func start &> ~/output.txt &
# Stop the background functions host (either in bash or PowerShell):
# - pkill func
# - Stop-Process -Name "func"

# To test the function, just browse to: http://localhost:7071/api/HelloWorld?name=Functions

# To execute the function locally, you may need to add the following Proxy settings to 'local.settings.json':
#
# "http_proxy": "http://mycorporateproxy.com:mycorporateport",
# "https_proxy": "http://mycorporateproxy.com:mycorporateport",
# "no_proxy": "localhost,127.0.0.1",
# "HTTP_PROXY": "http://mycorporateproxy.com:mycorporateport",
# "HTTPS_PROXY": "http://mycorporateproxy.com:mycorporateport",
# "NO_PROXY": "localhost,127.0.0.1"
#

# Create supporting Azure resources for your function:
# https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-csharp?tabs=azure-powershell%2Cbrowser
# 1- Sign in to Azure. 
#    Connect-AzAccount -UseDeviceAuthentication
# 2- Create a resource group named "rg-testappname-shared-001" in the westus region.
#    New-AzResourceGroup -Name "rg-testappname-shared-001" -Location westus
# 3- Create a general-purpose storage account in your resource group and region.
#    New-AzStorageAccount -ResourceGroupName "rg-testappname-shared-001" -Name "stappdata001" -SkuName Standard_LRS -Location westus
# 4- Create the function app in Azure.
#    New-AzFunctionApp -Name <APP_NAME> -ResourceGroupName "rg-testappname-shared-001" -StorageAccount "stappdata001" -Runtime dotnet -FunctionsVersion 3 -Location 'West US'
# 5- Deploy the function project to Azure.
#    func azure functionapp publish <APP_NAME>
# 6- Run the following command to view near real-time streaming logs.
#    func azure functionapp logstream <APP_NAME>
# 7- Clean up resources.
#    Remove-AzResourceGroup -Name "rg-testappname-shared-001"
