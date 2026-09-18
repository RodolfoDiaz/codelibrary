# ==============================================================================
# Install Azure CLI - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
# ==============================================================================

Write-Host "Select an installation method for Azure CLI:" -ForegroundColor Cyan
Write-Host "1) Winget (Recommended for Windows 11)"
Write-Host "2) MSI Download (PowerShell Direct)"

$selection = Read-Host "Enter option (1 or 2)"

switch ($selection) {
    "1" {
        Write-Host "Installing Azure CLI via winget..." -ForegroundColor Green
        winget install --id Microsoft.AzureCLI --exact --source winget --accept-package-agreements --accept-source-agreements
    }
    "2" {
        Write-Host "Downloading and installing Azure CLI via MSI..." -ForegroundColor Green
        
        $tempPath = Join-Path -Path$env:TEMP -ChildPath "AzureCLIInstall"
        if (-not (Test-Path -Path $tempPath)) {
            New-Item -Path $tempPath -ItemType Directory | Out-Null
        }

        $msiPath = Join-Path -Path$tempPath -ChildPath "AzureCLI.msi"

        # Download latest Azure CLI installer
        Invoke-WebRequest -Uri "https://aka.ms/installazurecliwindows" -OutFile $msiPath -UseBasicParsing

        # Run installer silently and wait for completion
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait

        # Clean up installer file
        Remove-Item -Path $msiPath -Force -ErrorAction SilentlyContinue
        Write-Host "MSI Installation completed successfully." -ForegroundColor Green
    }
    Default {
        Write-Warning "Invalid selection. Please run the script again and choose option 1 or 2."
    }
}