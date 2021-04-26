# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Virtual Machines - https://docs.microsoft.com/en-us/azure/virtual-machines/
# Example taken from Azure Quickstart Templates
# https://azure.microsoft.com/en-us/resources/templates/

# Azure Resource Manager - Reference:
# https://docs.microsoft.com/en-us/cli/azure/deployment/group
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Deploy network resources and Virtual Machine.


# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount -UseDeviceAuthentication
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.Compute", "Microsoft.Storage", "Microsoft.Network", "Microsoft.KeyVault") | ForEach-Object {
  Register-AzResourceProvider -ProviderNamespace $_
}


# --------------- 2 --------------- 
Write-Host "---> Creating resource group" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/module/az.resources/
$rndResourceGroup = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
$paramResourceGroup = "rg-testappname-shared-$rndResourceGroup"
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
Write-Host "---> Deploy network resources and Virtual Machine" -ForegroundColor Green
# See template/parameter details here: https://azure.microsoft.com/en-us/resources/templates/101-vm-simple-windows/
$paramTemplateUri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-windows/azuredeploy.json"
$paramJsonFile = "vm-parameters.json"
New-AzResourceGroupDeployment -ResourceGroupName "$paramResourceGroup" `
  -TemplateUri "$paramTemplateUri" `
  -TemplateParameterFile "$paramJsonFile"

# Cleanup 
# Remove Resource Group - Get-Help Remove-AzResourceGroup -Online
# Get-AzResourceGroup -Name $paramResourceGroup | Remove-AzResourceGroup -Force
