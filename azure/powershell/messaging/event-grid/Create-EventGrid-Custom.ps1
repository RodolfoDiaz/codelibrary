# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Event Grid - https://docs.microsoft.com/en-us/azure/event-grid/

# Azure Event Grid works in a Publisher - Subscriber model. In this case, your solution produce
# discrete events, that report state changes that a system can act on (enable subscribers to take action).
# For example, an IoT device that sends a message saying 'the alarm was set and somebody open a door', 
# then a system takes some action (call the police, send a security guard).
# Other examples: an account was created or an image uploaded, if something is listening or subscribing 
# to that event, there's generally some action that it takes upon receiving the notification.

# In Azure portal you create a resource "Event Grid Topics", to setup the event grid topic with 
# custom event to a web endpoint (Web hook)
# Quickstart code: Route custom events to web endpoint with PowerShell and Event Grid
# https://docs.microsoft.com/en-us/azure/event-grid/custom-event-quickstart-powershell

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a custom topic.
# 4- Create a message endpoint.
# 5- Subscribe to a topic.
# 6- Send an event to your topic.


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
Write-Host "---> Create a custom topic" -ForegroundColor Green
$rndTopic = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
$topicname = "test-topic-$rndTopic"
$eventGridTopic = New-AzEventGridTopic -ResourceGroupName "$paramResourceGroup" -Location "$paramLocation" -Name "$topicname" -Tag $paramTags
Write-Host "---> Event Grid Topic details:" -ForegroundColor Green
$eventGridTopic


# --------------- 4 --------------- 
Write-Host "---> Create a message endpoint" -ForegroundColor Green
$rndSite = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
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


# --------------- 5 --------------- 
Write-Host "---> Subscribe to a topic" -ForegroundColor Green
$endpoint = "https://$sitename.azurewebsites.net/api/updates"
$eventSubscriptionName = "gridCustomTest"

$eventGridSubscription = New-AzEventGridSubscription `
  -EventSubscriptionName "$eventSubscriptionName" `
  -Endpoint "$endpoint" `
  -ResourceGroupName "$paramResourceGroup" `
  -TopicName "$topicname"

Write-Host "---> Event Grid Subscription details:" -ForegroundColor Green
$eventGridSubscription


# --------------- 5 --------------- 
Write-Host "---> Send an event to your topic" -ForegroundColor Green
$endpoint = (Get-AzEventGridTopic -ResourceGroupName "$paramResourceGroup" -Name "$topicname").Endpoint
$keys = Get-AzEventGridTopicKey -ResourceGroupName "$paramResourceGroup" -Name "$topicname"

$eventID = Get-Random 99999

# Date format should be SortableDateTimePattern (ISO 8601)
$eventDate = Get-Date -Format s

# Construct body using Hashtable
$htbody = @{
  id          = $eventID
  eventType   = "recordInserted"
  subject     = "myapp/vehicles/motorcycles"
  eventTime   = $eventDate   
  data        = @{
    make  = "Ducati"
    model = "Monster"
  }
  dataVersion = "1.0"
}

# Use ConvertTo-Json to convert event body from Hashtable to JSON Object
# Append square brackets to the converted JSON payload since they are expected in the event's JSON payload syntax
$body = "[" + (ConvertTo-Json $htbody) + "]"

Invoke-WebRequest -Uri $endpoint -Method POST -Body $body -Headers @{"aeg-sas-key" = $keys.Key1 }
