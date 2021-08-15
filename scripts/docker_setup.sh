# Install Docker Engine on Ubuntu
# https://docs.docker.com/engine/install/ubuntu/

# Where docker volumes are located? https://docs.docker.com/storage/volumes/
# Folder location in Linux: /var/lib/docker/volumes
# Folder location in Docker Desktop (Windows):
# \\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

  if [ "$1" == "" ]; then
      echo "No argurment found. Use 'i' to install Docker, 'c' to create sample container, 'u' to execute image update and cleanup, 'l' to list containers/images, 'r' to remove Docker, 's' to start the service."
  fi

  if [ "$1" == "i" ]; then
    # -*- Set up the repository -*-

    ## Update the apt package index and install packages to allow apt to use a repository over HTTPS.
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

    ## Add Docker’s official GPG key.
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    ##  Set up the stable repository. 
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # -*- Install Docker Engine -*-

    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose

    # -*- Start the service -*-
    sudo service docker start

    # -*- Manage Docker as a non-root user -*-
    # If you don’t want to preface the docker command with sudo, create a Unix group called docker and add users to it. 
    # When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group.

    sudo groupadd docker

    sudo usermod -aG docker $USER

    echo "---> Log out and log back in so that your group membership is re-evaluated."

    read -p "Docker was installed. Press any key to continue ..."
    
    # Continue to Post-installation steps for Linux - https://docs.docker.com/engine/install/linux-postinstall/

fi

if [ "$1" == "c" ]; then
    
    # Verify that Docker Engine is installed correctly by running the hello-world image.
    echo "---> Create a container"
    # https://docs.docker.com/engine/reference/commandline/run/
    docker run --name hw1 hello-world

    echo "---> Start an existing container"
    # https://docs.docker.com/engine/reference/commandline/start/
    docker start --attach --interactive hw1

  fi

  if [ "$1" == "s" ]; then
    # Start the service
    sudo service docker start
    sudo service docker status
  fi

  if [ "$1" == "r" ]; then
    # Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them:
    # sudo apt purge docker docker-engine docker.io containerd runc

    echo "---> Uninstall the Docker Engine, CLI, and Containerd packages."
    sudo apt purge docker-ce docker-ce-cli containerd.io docker-compose
    echo "---> Delete all images, containers, and volumes."
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    echo "---> Delete(remove) the docker group from the system"
    sudo groupdel docker
  fi

  if [ "$1" == "l" ]; then

    echo "---> See a list of all containers, even the ones not running"
    docker ps -a

    echo "---> Show all images on this machine"
    docker images -a

  fi

  if [ "$1" == "u" ]; then
    
    echo "---> Update all docker images"
    docker images | awk '!/REPOSITORY/ {print $1}' | xargs -L1 docker pull

    echo "---> Show all the dangling images (untagged images)"
    docker images -f "dangling=true" -q

    echo "---> Remove all unused (dangling) images"
    # [LEGACY METHOD] docker rmi $(docker images -f "dangling=true" -q)
    docker system prune --force

    echo "---> Remove all local volumes not used by at least one container."
    docker volume prune --force

    #echo "---> Remove all stopped containers, unused networks, all images, all build cache."
    # docker system prune -a
  fi

else 
  echo 'This script is only for Linux.'
fi
