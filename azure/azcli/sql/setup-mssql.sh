# Install SQL Server
if [ "$(expr substr $(uname -s) 1 5)" != "Linux" ]; then
  echo 'This script is only for Linux'
  exit
fi

# Configure the password for 'sa' user (SQL Server Authentication)
paramServerPassword="ChangeThisPassword@123"

# Import the public repository GPG keys:
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft SQL Server Ubuntu repository for SQL Server 2019:
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list)"

# Run the following commands to install SQL Server:
sudo apt-get update
sudo apt-get install -y mssql-server

# Unattended install
# The following example configures the Developer edition of SQL Server with the MSSQL_PID environment variable. 
# It also accepts the EULA (ACCEPT_EULA) and sets the SA user password (MSSQL_SA_PASSWORD).
sudo MSSQL_PID=Developer ACCEPT_EULA=Y MSSQL_SA_PASSWORD="$paramServerPassword" /opt/mssql/bin/mssql-conf -n setup

# Once the configuration is done, verify that the service is running:
systemctl status mssql-server --no-pager
