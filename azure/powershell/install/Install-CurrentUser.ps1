# To install PowerShell on Windows, download the latest install package from:
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows
#
# Install Azure PowerShell modules.
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps
# Using the PowerShellGet cmdlets is the preferred installation method. 
# Install the Az module for the current user only. This is the recommended installation scope.
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
      'Az modules installed at the same time is not supported.')
} else {
    if ($IsWindows) {
        Get-ExecutionPolicy -List
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    }
    Install-Module -Name Az -Repository PSGallery -Force
    Get-Module -Name Az -ListAvailable
}
Write-Host "---> Your PowerShell Modules path is: " -ForegroundColor Green
$env:PSModulePath
Write-Host "---> To update Azure PowerShell modules use the following command: Update-Module -Name Az -Force" -ForegroundColor Green