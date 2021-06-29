# Install SQL Server command-line tools on Linux
# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools

if [ "$(expr substr $(uname -s) 1 5)" != "Linux" ]; then
  echo 'This script is only for Linux'
  exit
fi

if [ -n "$(uname -a | grep Ubuntu)" ]; then
  echo "---> Install sqlcmd and bcp the SQL Server command-line tools on Ubuntu Linux"
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
  sudo apt update
  sudo ACCEPT_EULA=Y apt install -y mssql-tools unixodbc-dev
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