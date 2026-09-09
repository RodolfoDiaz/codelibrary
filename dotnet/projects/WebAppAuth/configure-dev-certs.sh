#!/usr/bin/env bash
# ==============================================================================
# Script: configure-dev-certs.sh
# Description:
#   Automates the generation, trust, and environment configuration for .NET Core
#   HTTPS development certificates on WSL (Windows Subsystem for Linux).
#
# Key Actions:
#   1. Cleans existing HTTPS development certificates.
#   2. Generates a fresh PFX certificate and marks it trusted within .NET.
#   3. Exports the public certificate into Windows Temp and imports it into the
#      Windows Current User Trusted Root Certification Authority using certutil.exe.
#   4. Persists required environment variables (SSL_CERT_DIR, ASPNETCORE Kestrel settings)
#      to ~/.bashrc and exports them for the active session.
# ==============================================================================

set -euo pipefail

echo "=== Current SSL_CERT_DIR value: ${SSL_CERT_DIR:-Not Set} ==="

echo "=== 1. Cleaning old .NET HTTPS development certificates ==="
dotnet dev-certs https --clean

echo "=== 2. Generating fresh certificate and PFX bundle for Kestrel ==="
mkdir -p "$HOME/.aspnet/dev-certs"
CERT_PFX_PATH="$HOME/.aspnet/dev-certs/localhost.pfx"
CERT_PASSWORD="Password123!"

dotnet dev-certs https -ep "$CERT_PFX_PATH" -p "$CERT_PASSWORD"
dotnet dev-certs https --trust

# Linux/WSL uses OpenSSL to manage trusted certificates, but .NET cannot automatically
# add its certificate to system-wide trust stores or your environment variables without configuration.
echo "=== 3. Exporting certificate for Windows Trust Store ==="
WIN_TEMP_DIR="/mnt/c/Windows/Temp"
CRT_NAME="wsl-dotnet-dev-cert.crt"
WIN_CRT_PATH_LINUX="$WIN_TEMP_DIR/$CRT_NAME"
WIN_CRT_PATH_WINDOWS="C:\\Windows\\Temp\\$CRT_NAME"

dotnet dev-certs https -ep "$WIN_CRT_PATH_LINUX" --format Pem

echo "=== 4. Importing certificate into Windows Root Store ==="
cmd.exe /c "certutil -user -addstore root $WIN_CRT_PATH_WINDOWS"

# Clean up exported CRT file
rm -f "$WIN_CRT_PATH_LINUX"

echo "=== 5. Configuring shell environment variables ==="
BASHRC="$HOME/.bashrc"

# Function to add env var to bashrc if missing
add_env_var() {
    local var_line="$1"
    if ! grep -qF "$var_line" "$BASHRC"; then
        echo "$var_line" >> "$BASHRC"
    fi
}

add_env_var 'export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:/usr/lib/ssl/certs"'
add_env_var "export ASPNETCORE_Kestrel__Certificates__Default__Path=\"$CERT_PFX_PATH\""
add_env_var "export ASPNETCORE_Kestrel__Certificates__Default__Password=\"$CERT_PASSWORD\""

# Apply to current session
export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:/usr/lib/ssl/certs"
export ASPNETCORE_Kestrel__Certificates__Default__Path="$CERT_PFX_PATH"
export ASPNETCORE_Kestrel__Certificates__Default__Password="$CERT_PASSWORD"

echo ""
echo "========================================================="
echo " Setup complete! "
echo " Environment variables added to ~/.bashrc and applied."
echo " You can now run your .NET app with: dotnet run"
echo "========================================================="

echo ""
echo "Checking for the existence of the certificate in the trust store..."
ls -la "$HOME/.aspnet/dev-certs/"
dotnet dev-certs https --trust --check

# By default, the "dotnet dev-certs https" command generates and installs the certificate
# strictly at the Current User level (certmgr.msc), not the machine level (certlm.msc).

# To find them, press Win + R, type certmgr.msc (Current User Certificate Manager),
# and look in:
# * Personal - Certificates: Certificate with Issued To / Issued By set to "localhost"
#   and Friendly Name set to "ASP.NET Core HTTPS development certificate".
# * Trusted Root Certification Authorities - Certificates: The mirrored "localhost" certificate.
