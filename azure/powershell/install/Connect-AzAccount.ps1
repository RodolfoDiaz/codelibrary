# https://docs.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount
# -UseDeviceAuthentication - Use device code authentication instead of a browser control.
Connect-AzAccount -UseDeviceAuthentication

# List all users
Get-AzADUser

# Get subscriptions that the current account can access.
Get-AzSubscription
