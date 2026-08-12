# Uninstall Azure PowerShell modules.
# https://learn.microsoft.com/en-us/powershell/azure/uninstall-az-ps

Get-InstalledModule -Name Az -AllVersions -OutVariable AzVersions

($AzVersions |
  ForEach-Object {
    Import-Clixml -Path (Join-Path -Path $_.InstalledLocation -ChildPath PSGetModuleInfo.xml)
  }).Dependencies.Name | Sort-Object -Descending -Unique -OutVariable AzModules

$AzModules |
  ForEach-Object {
    Remove-Module -Name $_ -ErrorAction SilentlyContinue
    Write-Output "Attempting to uninstall module: $_"
    Uninstall-Module -Name $_ -AllVersions
  }

Remove-Module -Name Az -ErrorAction SilentlyContinue
Uninstall-Module -Name Az -AllVersions