# Install SQL Server tools
# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver15
if [ "$(uname)" == "Darwin" ]; then
  echo "---> Install tools on macOS from the link provided in this script."
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  if [ -n "$(uname -a | grep Ubuntu)" ]; then
    echo "---> Install sqlcmd and bcp the SQL Server command-line tools on Ubuntu Linux"
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
    sudo apt-get update
    sudo ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
    source ~/.bashrc
  else
    echo "---> Install sqlcmd and bcp the SQL Server command-line tools on RHEL"
    sudo su
    curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/msprod.repo
    exit
    sudo yum check-update
    sudo yum install mssql-tools unixODBC-devel
  fi
else
 echo "---> This script is only intended to run on Linux."
fi
