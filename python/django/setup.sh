#sudo apt-get update
#sudo apt-get -y install python
#sudo apt-get -y install python-pip
sudo -H pip install -U pip 
sudo -H pip install django --upgrade
echo "Django version is: "
python -m django --version