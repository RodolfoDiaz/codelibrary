echo "The version of PowerShell running on your machine: "
Get-Host
# Get-Host | Select-Object Version
# (Get-Host).Version
 
# Alternatively, type $PSVersionTable and hit the Enter key.
# $PSVersionTable.PSVersion

echo "The version of Azure module installed is: "
Get-InstalledModule -Name Az | Select-Object Name, Version, Type, PublishedDate

# [System.Console]::WriteLine("This is a test!")