# To install PowerShell on Windows, download the latest install package from:
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows
#
# Install Azure PowerShell modules.
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps
# Installing the module for all users on a system requires elevated privileges. 
# Start the PowerShell session using Run as administrator in Windows or use the sudo command on macOS or Linux.
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
      'Az modules installed at the same time is not supported.')
} else {
    Install-Module -Name Az -AllowClobber -Scope AllUsers
}