# Using Azure Functions Core Tools
# https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local

# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

Write-Host "--> This example uses the following: " -ForegroundColor Green
Write-Host "---> Azure Functions Core Tools version 3.x." -ForegroundColor Green
func --version
Write-Host "---> .NET Core SDK 3.1 or above" -ForegroundColor Green
dotnet --version

# VARIABLES 
$AppName = "mytest-func"  # New-Variable -Name "AppName" -Visibility Public -Value "mytest-func"
$functionName = "HelloWorld"  # New-Variable -Name "functionName" -Visibility Public -Value "HelloWorld"

# Cleanup
if ( Test-Path -Path $AppName -PathType Container ) { Remove-Item -path $AppName -Recurse –force }

New-Item -ItemType directory -Path $AppName
Set-Location -Path $AppName

Write-Host "--> Create the FunctionApp" -ForegroundColor Green
func init --worker-runtime "dotnet"

Write-Host "--> Restore NuGet package(s)" -ForegroundColor Green
dotnet restore

Write-Host "--> Compile the solution" -ForegroundColor Green
dotnet build

Write-Host "--> Create new function" -ForegroundColor Green
func new --language "C#" --template "HttpTrigger" --name $functionName

Write-Host "--> Execute the FunctionApp locally" -ForegroundColor Green
func start --verbose

# To test the function, just browse to: http://localhost:7071/api/HelloWorld?name=Functions

# Create supporting Azure resources for your function:
# https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-csharp?tabs=azure-powershell%2Cbrowser
# 1- Sign in to Azure. 
#    Connect-AzAccount
# 2- Create a resource group named AzureFunctionsQuickstart-rg in the westeurope region.
#    New-AzResourceGroup -Name AzureFunctionsQuickstart-rg -Location westus
# 3- Create a general-purpose storage account in your resource group and region.
#    New-AzStorageAccount -ResourceGroupName AzureFunctionsQuickstart-rg -Name <STORAGE_NAME> -SkuName Standard_LRS -Location westus
# 4- Create the function app in Azure.
#    New-AzFunctionApp -Name <APP_NAME> -ResourceGroupName AzureFunctionsQuickstart-rg -StorageAccount <STORAGE_NAME> -Runtime dotnet -FunctionsVersion 3 -Location 'West US'
# 5- Deploy the function project to Azure.
#    func azure functionapp publish <APP_NAME>
# 6- Run the following command to view near real-time streaming logs.
#    func azure functionapp logstream <APP_NAME>
# 7- Clean up resources.
#    Remove-AzResourceGroup -Name AzureFunctionsQuickstart-rg
