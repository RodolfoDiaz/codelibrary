if [ "$(expr substr $(uname -s) 1 5)" != "Linux" ]; then
  echo 'This script is only for Linux.'
  exit
fi

if [ "$1" == "" ]; then
    echo "No argurment found. Use 'i' to install common packages, 'u' to update/upgrade all, 'l' to list installed packages, 'r' to autoremove unused packages, 's' to search."
elif [ "$1" == "u" ]; then
  # Update/upgrade the system by installing/upgrading packages
  sudo apt update -y
  sudo apt upgrade -y
elif [ "$1" == "i" ]; then
  # Install common packages
  sudo apt install build-essential
  sudo apt install zip unzip -y
  sudo apt install unrar -y
elif [ "$1" == "l" ]; then
  # List Installed Packages
  apt list --installed
elif [ "$1" == "s" ]; then
  # Search for packages installed with a pattern
  if [ "$2" == "" ]; then
    echo "No search pattern found. Enter a command name, for example: ./linux_config.sh s zip"
    exit
  fi
  echo "---> List packages installed (dpkg)"
  dpkg --list *$2* | grep --invert-match none
  # echo "---> List packages installed (apt list)"
  # apt list --installed | grep $2
elif [ "$1" == "r" ]; then
  # Remove automatically all unused packages
  sudo apt autoremove -y
  # Removing all residual config packages in Ubuntu:
  sudo apt-get remove --purge `dpkg -l | grep '^rc' | awk '{print $2}'`
fi
