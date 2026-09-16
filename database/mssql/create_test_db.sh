#!/usr/bin/env bash
set -e

# 1. Display running SQL Server containers
echo "=== Running Containers ==="
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | grep -iE "mssql|sqlserver|HEADER"
echo "===================================="
echo ""

# 2. Get Container Name/ID (cli argument or interactive prompt)
CONTAINER_NAME="$1"
if [ -z "$CONTAINER_NAME" ]; then
    read -rp "Enter Container ID or Name: " CONTAINER_NAME
fi

# 3. Get SA Password (cli argument or interactive prompt)
SA_PASSWORD="$2"
if [ -z "$SA_PASSWORD" ]; then
    read -sp "Enter SA Password: " SA_PASSWORD
    echo ""
fi

# Validate inputs are not empty
if [ -z "$CONTAINER_NAME" ] || [ -z "$SA_PASSWORD" ]; then
    echo "Error: Container ID/Name and SA Password are required."
    exit 1
fi

# 4. Load Environment Variables (.env)
if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
else
    echo "Error: .env file not found."
    exit 1
fi

# Validate .env contents
if [ -z "$MSSQL_DB" ] || [ -z "$MSSQL_USER" ] || [ -z "$MSSQL_PASSWORD" ]; then
    echo "Error: .env must contain MSSQL_DB, MSSQL_USER, and MSSQL_PASSWORD."
    exit 1
fi

# 5. Build SQL Script
SQL_COMMANDS=$(
    cat << EOF
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'${MSSQL_DB}')
BEGIN
    CREATE DATABASE [${MSSQL_DB}];
END
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = N'${MSSQL_USER}')
BEGIN
    CREATE LOGIN [${MSSQL_USER}] WITH PASSWORD = N'${MSSQL_PASSWORD}';
END
GO

USE [${MSSQL_DB}];
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = N'${MSSQL_USER}')
BEGIN
    CREATE USER [${MSSQL_USER}] FOR LOGIN [${MSSQL_USER}];
    ALTER ROLE db_owner ADD MEMBER [${MSSQL_USER}];
END
GO
EOF
)

# 6. Execute inside container
docker exec -i "$CONTAINER_NAME" \
    /opt/mssql-tools18/bin/sqlcmd \
    -S localhost \
    -U sa \
    -P "$SA_PASSWORD" \
    -C \
    -Q "$SQL_COMMANDS"

echo "SQL Server: Database '${MSSQL_DB}' and user '${MSSQL_USER}' configured successfully."
