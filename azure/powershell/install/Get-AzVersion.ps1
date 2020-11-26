if (Get-Module -Name Az -ListAvailable) {
  Get-InstalledModule -Name Az -AllVersions | Select-Object -Property Name, Version
  # Get-Module -Name Az.* -ListAvailable
}
else {
  Write-Warning -Message ('Az module is not installed.')
}