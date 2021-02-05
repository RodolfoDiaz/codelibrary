Write-Output "The version of PowerShell running on your machine: "
$PSVersionTable
# Get-Host

Write-Output "The version of Azure PowerShell module installed is: "
if (Get-Module -Name Az -ListAvailable) {
  Get-InstalledModule -Name Az | Select-Object Name, Version, Type, PublishedDate
}
else {
  Write-Warning -Message ('Az module is not installed.')
}

# [System.Console]::WriteLine("This is a test!")