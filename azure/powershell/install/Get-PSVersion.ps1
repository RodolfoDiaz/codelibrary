Write-Output "The version of PowerShell running on your machine: "
Get-Host
# Get-Host | Select-Object Version
# (Get-Host).Version
 
# Alternatively, type $PSVersionTable and hit the Enter key.
# $PSVersionTable.PSVersion

Write-Output "The version of Azure module installed is: "
if (Get-Module -Name Az -ListAvailable) {
  Get-InstalledModule -Name Az | Select-Object Name, Version, Type, PublishedDate
}
else {
  Write-Warning -Message ('Az module is not installed.')
}

# [System.Console]::WriteLine("This is a test!")