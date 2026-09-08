#!/usr/bin/env bash
set -e

echo "SSL_CERT_DIR is equal to: ${SSL_CERT_DIR}"

# Add Certificate Path to Environment Variables
if [ -z "${SSL_CERT_DIR:-}" ]; then
    echo 'export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:/usr/lib/ssl/certs"' >> ~/.bashrc
    source ~/.bashrc
fi

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
ll ~/.aspnet/dev-certs/
dotnet dev-certs https --trust --check

# By default, the "dotnet dev-certs https" command generates and installs the certificate
# strictly at the Current User level (certmgr.msc), not the machine level (certlm.msc).

# To find them, you must press Win + R, type certmgr.msc (Current User Certificate Manager),
# and click Enter, then look in the following folders:
# * Personal - Certificates: You will find a certificate with the Issued To / Issued By name set to
#   localhost. Under the Friendly Name column, it will be labeled ASP.NET Core HTTPS development certificate.

# * Trusted Root Certification Authorities - Certificates: If you previously ran dotnet dev-certs https --trust,
#   a copy of that same localhost certificate will also be mirrored here so your web browsers trust it.
#   Columns "Issued To" and "Issued By" columns will be set to localhost for the certificate created here.
