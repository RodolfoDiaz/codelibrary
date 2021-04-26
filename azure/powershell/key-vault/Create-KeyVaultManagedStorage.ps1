# In StrictMode PowerShell generates a terminating error when the content of 
# an expression or script-block violates basic best-practice coding rules.
Set-StrictMode -Version latest
# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Azure Key Vault - https://docs.microsoft.com/en-us/azure/key-vault/general/
# https://docs.microsoft.com/en-us/azure/key-vault/secrets/overview-storage-keys-powershell

# Manage storage account keys with Key Vault:
# - Microsoft recommends using Azure Key Vault to manage and rotate your access keys. 
#   Your application can securely access your keys in Key Vault, so that you can avoid storing them with your application code.
# - Microsoft recommends that you rotate your access keys periodically to help keep your storage account secure. 
#   If possible, use Azure Key Vault to manage your access keys. If you are not using Key Vault, you will need to rotate your keys manually.

# The deployment process is:
# 1- Log in to Azure.
# 2- Create a resource group.
# 3- Create a Key Vault.
# 4- Create a storage account.
# 5- Give Key Vault access to your storage account.
# 6- Give your user account permission to managed storage accounts.
# 7- Add a managed storage account to your Key Vault instance.
# 8- Create Shared access signature tokens.
# 9- Create a blob container and upload file.


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
Write-Host "---> Create a Key Vault" -ForegroundColor Green
# Key Vault naming rule: length	3-24, Alphanumerics and hyphens.
$rndKV = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
$keyVaultName = "test-keyvault-$rndKV"
$paramSku = "standard" # Allowed values for Vault: premium, standard.
$ketVault = New-AzKeyVault -Name "$keyVaultName" -EnablePurgeProtection -Sku "$paramSku" `
  -ResourceGroupName "$paramResourceGroup" -Location "$paramLocation" -Tag $paramTags
Write-Host "---> Key Vault details:" -ForegroundColor Green
$ketVault


# --------------- 4 --------------- 
Write-Host "---> Creating a storage account" -ForegroundColor Green
# We need a storage account for the deployed code to live in. Storage accounts also
# need a globally unique name, so we"ll take the first section of a GUID and append it 
# to the storage account name. That should be suitable to make it globally unique.
$rndAcct = "{0:D5}" -f ( Get-Random -Minimum 0 -Maximum 99999 )
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
$storageAccountName = "teststorage$rndAcct"
$paramStorageSku = "Standard_LRS"  # https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
$paramStorageKind = "StorageV2"     # https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
$newStorageParams = @{
  ResourceGroupName = $paramResourceGroup
  AccountName       = $storageAccountName
  Location          = $paramLocation
  SkuName           = $paramStorageSku
  Tag               = $paramTags
  Kind              = $paramStorageKind
}
# Create new Storage Account - Get-Help New-AzStorageAccount -Online
$storageAccount = New-AzStorageAccount @newStorageParams
Write-Host "---> Storage Account details:" -ForegroundColor Green
$storageAccount


# --------------- 5 --------------- 
Write-Host "---> Give Key Vault access to your storage account" -ForegroundColor Green

# Key Vault is a Microsoft application that's pre-registered in all Azure AD tenants. Key Vault is registered under the same Application ID in each Azure cloud.
# https://docs.microsoft.com/en-us/azure/key-vault/secrets/overview-storage-keys-powershell#service-principal-application-id
$keyVaultSpAppId = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
$storageAccountKey = "key1" #(key1 or key2 are allowed)
$paramUserPrincipal = (Get-AzADUser).UserPrincipalName

# Assign Azure role "Storage Account Key Operator Service Role" to Key Vault, limiting the access scope to your storage account. For a classic storage account, use "Classic Storage Account Key Operator Service Role."
New-AzRoleAssignment -ApplicationId $keyVaultSpAppId -RoleDefinitionName 'Storage Account Key Operator Service Role' -Scope $storageAccount.Id


# --------------- 6 --------------- 
Write-Host "---> Give your user account permission to managed storage accounts" -ForegroundColor Green
# Give your user principal access to all storage account permissions, on your Key Vault instance
Set-AzKeyVaultAccessPolicy -VaultName "$keyVaultName" -UserPrincipalName "$paramUserPrincipal" `
  -PermissionsToStorage get, list, delete, set, update, regeneratekey, getsas, listsas, deletesas, setsas, recover, backup, restore, purge
Write-Host "---> Permission assigned!"


# --------------- 7 --------------- 
Write-Host "---> Add a managed storage account to your Key Vault instance" -ForegroundColor Green
# Add your storage account to your Key Vault's managed storage accounts
# https://docs.microsoft.com/en-us/powershell/module/az.keyvault/add-azkeyvaultmanagedstorageaccount

# You can disable Auto Regenerate Key
# Add-AzKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $storageAccountName -AccountResourceId $storageAccount.Id -ActiveKeyName $storageAccountKey -DisableAutoRegenerateKey

# If you want Key Vault to regenerate your storage account keys periodically, you can enable key regeneration
$regenPeriod = [System.Timespan]::FromDays(3)
Add-AzKeyVaultManagedStorageAccount -VaultName "$keyVaultName" -AccountName "$storageAccountName" -AccountResourceId $storageAccount.Id -ActiveKeyName $storageAccountKey -RegenerationPeriod $regenPeriod
# Regenerate keys by using Key Vault only. Don't manually regenerate your storage account keys.


# --------------- 8 --------------- 
Write-Host "---> Create Shared access signature tokens" -ForegroundColor Green

$storageContext = New-AzStorageContext -StorageAccountName "$storageAccountName" -Protocol Https -StorageAccountKey Key1 #(or "Primary" for Classic Storage Account)

$start = [System.DateTime]::Now.AddDays(-1)
$end = [System.DateTime]::Now.AddMonths(1)
$sasToken = New-AzStorageAccountSasToken -Service blob, file, Table, Queue -ResourceType Service, Container, Object -Permission "racwdlup" -Protocol HttpsOnly -StartTime $start -ExpiryTime $end -Context $storageContext

# Sets an account SAS definition '$paramSASDefinition' on a KeyVault-managed storage account '$storageAccountName' in vault '$keyVaultName'. 
# https://docs.microsoft.com/en-us/powershell/module/az.keyvault/set-azkeyvaultmanagedstoragesasdefinition
$paramSASDefinition = "testStoragePermission1"
Set-AzKeyVaultManagedStorageSasDefinition -AccountName "$storageAccountName" -VaultName "$keyVaultName" -Name "$paramSASDefinition" -TemplateUri $sasToken -SasType 'account' -ValidityPeriod ([System.Timespan]::FromDays(30))


# --------------- 8 --------------- 
Write-Host "---> Verify the shared access signature definition" -ForegroundColor Green
$keyVaultSecret = Get-AzKeyVaultSecret -VaultName "$keyVaultName"
$keyVaultSecret

Write-Host "---> Get the SAS definition string"
$secret = Get-AzKeyVaultSecret -VaultName "$keyVaultName" -Name $keyVaultSecret.Name
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
try {
  $secretKeyVaultSASToken = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
}
finally {
  [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
}
# Using Azure Key Vault makes it easy to rotate your keys without interruption to your applications. You can also manually rotate your keys.
# https://docs.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-powershell
Write-Host "Shared Access Signature (SAS) token definition string: $secretKeyVaultSASToken" -ForegroundColor Magenta


# --------------- 9 --------------- 
Write-Host "---> Create a blob container and upload file" -ForegroundColor Green
# https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-powershell
$paramContainerName = "test-container"
$paramPublicAccess = "off" # By default, container data is private ("off") to the account owner. Use "blob" to allow public read access for blobs. Use "container" to allow public read and list access to the entire container.
$ctx = $storageAccount.Context
$storageContainer = New-AzStorageContainer -Name "$paramContainerName" -Context $ctx -Permission "$paramPublicAccess"
$storageContainer

$paramStandardBlobTier = "Cool"  # Block Blob Tier, valid values are Hot/Cool/Archive. https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-storage-tiers
$currentDateTime = Get-Date -Format "dddd MM/dd/yyyy HH:mm K"
Remove-Item ".\test.txt" -ErrorAction SilentlyContinue
New-Item ".\test.txt"
Set-Content ".\test.txt" "This is a test file! - $currentDateTime" 
$paramFileName = "test.txt"
$paramBlobName = "FolderA/FolderB/FolderC/$paramFileName" # Blob name prefixes (virtual directories)
Set-AzStorageBlobContent -File "$paramFileName" `
  -Container "$paramContainerName" `
  -Blob "$paramBlobName" `
  -Context $ctx `
  -StandardBlobTier "$paramStandardBlobTier"

$blobUrl = "https://$storageAccountName.blob.core.windows.net/$paramContainerName/$paramBlobName"
$blobUrlToken = -join ($blobUrl, "", "$secretKeyVaultSASToken")

Write-Host "Access a file using the managed access key" -ForegroundColor Green
Write-Host "$blobUrlToken"
Start-Process "$blobUrlToken"
