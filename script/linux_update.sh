if [ "$(uname)" == "Darwin" ]; then
    echo "This script is only intended to run on Linux."
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sudo apt update
    sudo apt upgrade
    sudo apt install build-essential dkms linux-headers-$(uname -r)
    sudo apt autoremove -y
else
   echo "This script is only intended to run on Linux."
fi