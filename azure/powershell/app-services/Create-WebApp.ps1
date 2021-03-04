# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure App Service - https://docs.microsoft.com/en-us/azure/app-service/

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create an App Service plan.
# 4- Create the Web App.


# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount -UseDeviceAuthentication
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.Web", "Microsoft.DomainRegistration") | ForEach-Object {
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
Write-Host "---> Create an App Service plan" -ForegroundColor Green
# https://azure.microsoft.com/en-us/pricing/details/app-service/
$rndAppService = (New-Guid).ToString().Split("-")[0]
$paramAppServicePlan = "app_service_plan_$rndAppService"
$paramTier = "Basic" # You have the choice between 5 SKUs: Free, Shared, Basic, Standard, Premium
$paramWorkerSize = "Small" # Accepted values:	Small, Medium, Large, ExtraLarge
$paramNumberofWorkers = "1" # worker pool instances, a number from 1 to 10
# App Service Plan explained:
# Free (F1) -> test and discover the hosting service. Free and Shared are only available in one size (Small).
# Shared (D1) -> basic apps with low traffic and not business critical.
# Basic -> dev and test of apps before production. B1 = Tier Basic + Size Small, B2 =	Tier Basic + Size Medium, B3 = Tier Basic + Size Large
# Standard -> apps in production. S1 = Tier Standard + Size Small, S2 =	Tier Standard + Size Medium, S3 = Tier Standard + Size Large
# Premium -> large scale apps in production. P1 = Tier Premium + Size Small, P2 =	Tier Premium + Size Medium, P3 = Tier Premium + Size Large

New-AzAppServicePlan -Name "$paramAppServicePlan" `
  -ResourceGroupName "$paramResourceGroup" -Location "$paramLocation" `
  -Tier "$paramTier" -WorkerSize "$paramWorkerSize" -NumberofWorkers "$paramNumberofWorkers" `
  -Tag $paramTags -Linux 

# The app must be running in the Standard, Premium, or Isolated tier in order for you to enable multiple deployment slots.
# New-AzWebAppSlot

# --------------- 4 --------------- 
Write-Host "---> Create the Web App" -ForegroundColor Green
$rndWebApp = (New-Guid).ToString().Split("-")[0]
$paramWebApp = "test-web-$rndWebApp"
New-AzWebApp -Name "$paramWebApp" `
  -ResourceGroupName "$paramResourceGroup" -Location "$paramLocation" `
  -AppServicePlan "$paramAppServicePlan"
