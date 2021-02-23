# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Service Bus Queues - https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-powershell

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a Service Bus messaging namespace.
# 4- Create a queue in the namespace you created.
# 5- Get the primary connection string for the namespace.
# 6- Create the application.

# The following commands are available in PowerShell:
# Get-Command -Module Az.ServiceBus

# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.ServiceBus", "Microsoft.Storage") | ForEach-Object {
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
Write-Host "---> Creating a Service Bus messaging namespace" -ForegroundColor Green
$rndsbns = (New-Guid).ToString().Split("-")[0]
# Namespace naming rules: length 6-50, Alphanumerics and hyphens.
$paramServiceBusNamespace = "test-servicebusnamespace-$rndsbns"
$paramNamespaceSku = "Basic"  # Service Bus comes in Basic, Standard, and Premium tiers. For Queues you need "Basic" - https://azure.microsoft.com/en-us/pricing/details/service-bus/
$serviceBusNamespace = New-AzServiceBusNamespace -ResourceGroupName "$paramResourceGroup" -Name "$paramServiceBusNamespace" -SkuName "$paramNamespaceSku" -Location "$paramLocation" -Tag $paramTags
Write-Host "---> Service Bus Namespace details:" -ForegroundColor Green
$serviceBusNamespace


# --------------- 4 --------------- 
Write-Host "---> Creating a queue in the namespace you created" -ForegroundColor Green
$rndqueue = (New-Guid).ToString().Split("-")[0]
$env:queueName = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:queueName = "test_servicebusqueue_$rndqueue"
$serviceBusQueue = New-AzServiceBusQueue -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Name "$env:queueName"
Write-Host "---> Service Bus Queue details:" -ForegroundColor Green
$serviceBusQueue


# --------------- 5 --------------- 
Write-Host "---> Get the primary connection string for the namespace" -ForegroundColor Green
$serviceBusKey = Get-AzServiceBusKey -ResourceGroupName "$paramResourceGroup" -Namespace "$paramServiceBusNamespace" -Name RootManageSharedAccessKey 
$serviceBusKey
$env:primaryConnectionString = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:primaryConnectionString = $serviceBusKey.PrimaryConnectionString
Write-Host "---> Primary Connection String" -ForegroundColor Green
$env:primaryConnectionString


# --------------- 6 --------------- 
Write-Host "---> Create the application" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-dotnet-get-started-with-queues
$appFolderName = "ServiceBusQueueApp"
$appProgramFile = "ProgramSBQ.cs"
if ( Test-Path -Path $appFolderName -PathType Container ) { Remove-Item -path $appFolderName -Recurse –force }
dotnet new console -n $appFolderName
Set-Location $appFolderName
dotnet add package Azure.Messaging.ServiceBus
Copy-Item ../$appProgramFile .
Move-Item $appProgramFile Program.cs -Force
Write-Host "---> Check your results" -ForegroundColor Green
dotnet build
# NOTE: If you receive a Timeout Exception, your environment is probably blocking the TCP ports
# used for AMQP by default. You need to have ports 5671 and 5672 opened for AMQP connections.
dotnet run
Set-Location ..
