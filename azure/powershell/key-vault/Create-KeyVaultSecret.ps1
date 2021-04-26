# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Key Vault - https://docs.microsoft.com/en-us/azure/key-vault/general/
# https://docs.microsoft.com/en-us/azure/key-vault/secrets/quick-create-powershell

# Azure Key Vault is a secret store: a centralized cloud service for storing application secrets.
# Key Vault allows users to store connection strings, secrets, passwords, certificates, access policies, 
# file locks (making items in Azure read-only), and automation scripts. 
# Key Vault is designed to store configuration secrets for server applications. It's not intended for 
# storing data belonging to your app's users, and it shouldn't be used in the client-side part of an app. 

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a Key Vault.
# 4- Create a secret in the KeyVault.
# 5- Get a secret from the key vault.


# --------------- 1 --------------- 
Write-Host "---> Log in to Azure" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps
Connect-AzAccount -UseDeviceAuthentication
#$tenantId = (Get-AzContext).Tenant.Id

Write-Host "---> Verify registration of the required Azure resource providers" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
@("Microsoft.KeyVault", "Microsoft.Storage") | ForEach-Object {
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
Write-Host "---> Create a Key Vault" -ForegroundColor Green
# Key Vault naming rule: length	3-24, Alphanumerics and hyphens.
$rndKV = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
$paramKeyVault = "kv-testappname-shared-$rndKV"
$paramSku = "standard" # Allowed values for Vault: premium, standard.
$ketVault = New-AzKeyVault -Name "$paramKeyVault" -EnablePurgeProtection -Sku "$paramSku" `
  -ResourceGroupName "$paramResourceGroup" -Location "$paramLocation" -Tag $paramTags
Write-Host "---> Key Vault details:" -ForegroundColor Green
$ketVault


Write-Host "---> Access policies: Give a user account permissions to access items in a Key Vault" -ForegroundColor Green
$currentlyLoggedInUser = Get-AzADUser
$paramUserPrincipal = $currentlyLoggedInUser.UserPrincipalName # You can take this value from Azure AD - Users -> User principal name
# See the full list of permissions here: https://docs.microsoft.com/en-us/powershell/module/az.keyvault/set-azkeyvaultaccesspolicy
Set-AzKeyVaultAccessPolicy -VaultName "$paramKeyVault" `
  -UserPrincipalName "$paramUserPrincipal"  `
  -PermissionsToSecrets get, set, delete `
  -PermissionsToCertificates list, get `
  -PermissionsToKeys list, get, create, update `
  -PermissionsToStorage list, get, set, update


# --------------- 4 --------------- 
Write-Host "---> Get a secret from the key vault" -ForegroundColor Green
# Secrets are small (less than 10K) data blobs protected by a HSM-generated key created with the Key Vault.
# Secrets exist to simplify the process of persisting sensitive settings that almost every application has: 
# storage account keys, .PFX files, SQL connection strings, data encryption keys, etc.

$paramSecretName1 = "SecretKey"
#$paramSecretDesc = "This is a secret key"
$paramSecretValue = ConvertTo-SecureString "Key-123$" -AsPlainText -Force
$secretObject = Set-AzKeyVaultSecret -VaultName "$paramKeyVault" `
  -Name "$paramSecretName1" -SecretValue $paramSecretValue -Tag $paramTags
Write-Host "---> Secret details:" -ForegroundColor Green
$secretObject


# --------------- 5 --------------- 
Write-Host "---> Get a secret from the key vault" -ForegroundColor Green
$secret = Get-AzKeyVaultSecret -VaultName "$paramKeyVault" -Name "$paramSecretName1"
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
try {
  $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
}
finally {
  [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
}
Write-Host "---> The secret key is $secretValueText" -ForegroundColor Magenta


# Cleanup 
# Remove Resource Group - Get-Help Remove-AzResourceGroup -Online
# Get-AzResourceGroup -Name $paramResourceGroup | Remove-AzResourceGroup -Force