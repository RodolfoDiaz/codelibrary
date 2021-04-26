# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Service Bus Topics - https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal

# Azure Service Bus Queues work in a Producer-Consumer model (one to one).
# Azure Service Bus Topics work in a Publisher-Subscriber model (one to many). Topics will have subscriptions.
# For each subscription we define a filter (there are 3 types: boolean filter, SQL filter and correlation filters)
# Azure Service Bus provides the following (compared to Storage Queues):
# - Support for receiving messages without polling (with AMQP 1.0)
# - Guaranteed message processing order (FIFO)
# - Detect duplicate messages
# - Messages can be up to 256 KB
# - Support publishing and consuming in batches
# - Service Bus queues are limited to 80 GB

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a Service Bus messaging namespace.
# 4- Create a topic in the namespace.
# 5- Create a few subscriptions to the topic.
# 6- Create a filter to the subscriptions.
# 7- Get the primary connection string for the namespace.
# 8- Create the application.

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
$rndResourceGroup = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
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
$rndsbns = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
# Namespace naming rules: length 6-50, Alphanumerics and hyphens.
$paramServiceBusNamespace = "test-servicebusnamespace-$rndsbns"
$paramNamespaceSku = "Standard"  # Service Bus comes in Basic, standard, and premium tiers. For Topics you need "Standard" - https://azure.microsoft.com/en-us/pricing/details/service-bus/
$serviceBusNamespace = New-AzServiceBusNamespace -ResourceGroupName "$paramResourceGroup" -Name "$paramServiceBusNamespace" -SkuName "$paramNamespaceSku" -Location "$paramLocation"  -Tag $paramTags
Write-Host "---> Service Bus Namespace details:" -ForegroundColor Green
$serviceBusNamespace


# --------------- 4 --------------- 
Write-Host "---> Creating a topic in the namespace" -ForegroundColor Green
$rndtopic = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
$env:paramServiceBusTopic = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:paramServiceBusTopic = "test_servicebustopic_$rndtopic"
$serviceBusTopic = New-AzServiceBusTopic -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Name "$env:paramServiceBusTopic" -EnablePartitioning $True
Write-Host "---> Service Bus Topic details:" -ForegroundColor Green
$serviceBusTopic


# --------------- 5 --------------- 
Write-Host "---> Creating a few subscriptions to the topic" -ForegroundColor Green
$env:paramServiceBusSubscription = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:paramServiceBusSubscription = "mysub"
$serviceBusSubscription = New-AzServiceBusSubscription -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Topic "$env:paramServiceBusTopic" -Name "$env:paramServiceBusSubscription"
$serviceBusSubscription
$serviceBusSubscription1 = New-AzServiceBusSubscription -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Topic "$env:paramServiceBusTopic" -Name "S1"
$serviceBusSubscription1
$serviceBusSubscription2 = New-AzServiceBusSubscription -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Topic "$env:paramServiceBusTopic" -Name "S2"
$serviceBusSubscription2
$serviceBusSubscription3 = New-AzServiceBusSubscription -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Topic "$env:paramServiceBusTopic" -Name "S3"
$serviceBusSubscription3


# --------------- 6 --------------- 
Write-Host "---> Create a filter to the subscriptions" -ForegroundColor Green
# Create a filter on the first subscription with a filter using custom properties (StoreId is one of Store1, Store2, and Store3).
$serviceBusRule1 = New-AzServiceBusRule -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Topic "$env:paramServiceBusTopic" -Subscription "S1" -Name "MyFilter1" -SqlExpression "StoreId IN ('Store1','Store2','Store3')"
$serviceBusRule1
# Create a filter on the second subscription with a filter using customer properties (StoreId = Store4)
$serviceBusRule2 = New-AzServiceBusRule -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Topic "$env:paramServiceBusTopic" -Subscription "S2" -Name "MyFilter2" -SqlExpression "StoreId = 'Store4'"
$serviceBusRule2
# Create a filter on the third subscription with a filter using customer properties (StoreId not in Store1, Store2, Store3, or Store4).
$serviceBusRule3 = New-AzServiceBusRule -ResourceGroupName "$paramResourceGroup" -NamespaceName "$paramServiceBusNamespace" -Topic "$env:paramServiceBusTopic" -Subscription "S3" -Name "MyFilter3" -SqlExpression "StoreId NOT IN ('Store1','Store2','Store3', 'Store4')"
$serviceBusRule3


# --------------- 7 --------------- 
Write-Host "---> Get the primary connection string for the namespace" -ForegroundColor Green
$serviceBusKey = Get-AzServiceBusKey -ResourceGroupName "$paramResourceGroup" -Namespace "$paramServiceBusNamespace" -Name RootManageSharedAccessKey 
$serviceBusKey
$env:primaryConnectionString = "" # Initialization - With PowerShell's StrictMode set to ON uninitialized variables are flagged as an error.
$env:primaryConnectionString = $serviceBusKey.PrimaryConnectionString
Write-Host "---> Primary Connection String" -ForegroundColor Green
$env:primaryConnectionString


# --------------- 8 --------------- 
Write-Host "---> Create the application" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-dotnet-how-to-use-topics-subscriptions
$appFolderName = "ServiceBusTopicApp"
$appProgramFile = "ProgramSBT.cs"
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
