# Install the Azure CLI - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

# Install Azure CLI on Windows - MSI with Command
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-powershell
#
# You can also install the Azure CLI using PowerShell. 
# Start PowerShell as administrator and run the following command:
cd C:\temp\
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
