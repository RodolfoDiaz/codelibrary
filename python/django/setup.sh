#apt-get update
#apt-get -y install python-pip
sudo -H pip install -U pip 
sudo -H pip install django --upgrade
echo "Django version is: "
python -m django --version