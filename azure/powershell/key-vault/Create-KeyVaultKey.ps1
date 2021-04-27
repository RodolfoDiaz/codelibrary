# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Key Vault - https://docs.microsoft.com/en-us/azure/key-vault/general/
# https://docs.microsoft.com/en-us/azure/key-vault/keys/quick-create-powershell

# Azure Key Vault is a cloud-based key management solution, making it easier to create and control the 
# encryption keys used to encrypt your data. 
# A given key in a key vault is a cryptographic asset destined for a particular use such as the asymmetric 
# master key of Microsoft Azure RMS, or the asymmetric keys used for SQL Server TDE (Transparent Data Encryption), 
# CLE (Column Level Encryption) and Encrypted backup.

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a Key Vault.
# 4- Create a Key in the KeyVault.
# 5- Get a Key from the key vault.


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
$paramKeyVault = "kv-shared-$rndKV"
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
Write-Host "---> Create a Key in the key vault" -ForegroundColor Green
# https://docs.microsoft.com/en-us/powershell/module/az.keyvault/add-azkeyvaultkey
$paramKey = "cryptographicKey1"
$paramDestination = "software" # accepted values: hsm, software
#$paramTypeOfKey = "RSA" # accepted values: EC, EC-HSM, RSA, RSA-HSM, oct, oct-HSM
$paramKeySize = "2048" # The key size in bits. For example: 2048, 3072, or 4096 for RSA. 128, 192, or 256 for oct.
$ExpireDate = (Get-Date).AddYears(2).ToUniversalTime()

# For production use, it's recommended to use a Hardware Security Module (HSM)-protected keys and use 
# software-protected keys in only test/pilot scenarios. There is an additional charge for HSM-backed keys per-month.

$key = Add-AzKeyVaultKey -Name "$paramKey" -VaultName "$paramKeyVault" `
  -Destination "$paramDestination" -Size "$paramKeySize" -Expires $ExpireDate -Tag $paramTags

Write-Host "---> Key details:" -ForegroundColor Green
$key

# # If you have an existing key in a .pfx file, you can upload it to Azure Key Vault. 
# # You can choose to protect the key with software or HSM. 
# $paramKeyPassword = = ConvertTo-SecureString -String "Password" -AsPlainText -Force
# $paramFileLocation = "C:\Contoso\ITPfx.pfx"
# $key = Add-AzKeyVaultKey -Name "$paramKey" -VaultName "$paramKeyVault" `
#   -KeyFilePath "$paramFileLocation" -KeyFilePassword $paramKeyPassword -Tag $paramTags


# --------------- 5 --------------- 
Write-Host "---> Get a Key from the key vault" -ForegroundColor Green
# Gets the public part of a stored key.
Get-AzKeyVaultKey -KeyName "$paramKey" -VaultName "$paramKeyVault"


# Cleanup 
# Remove Resource Group - Get-Help Remove-AzResourceGroup -Online
# Get-AzResourceGroup -Name $paramResourceGroup | Remove-AzResourceGroup -Force