# Install Docker Engine on Ubuntu
# https://docs.docker.com/engine/install/ubuntu/

# Where docker volumes are located? https://docs.docker.com/storage/volumes/
# Folder location in Linux: /var/lib/docker/volumes
# Folder location in Docker Desktop (Windows):
# \\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

  if [ "$1" == "" ]; then
    echo "No argurment found. Call this script with one of the following arguments: 
    'install' to install Docker Engine. 
    'create' to create sample container. 
    'update' to execute image update and cleanup.
    'list' to list containers/images.
    'remove_all' to remove all containers and associated volumes, networks and images.
    'uninstall' to remove Docker from this machine.
    'status' to check the Docker service status."
  fi

  if [ "$1" == "install" ]; then

    echo "Install Docker Engine on Ubuntu - https://docs.docker.com/engine/install/ubuntu/"

    read -p "Are you sure you want to proceed? (Y/N): " answer
    if [ "${answer,,}" != "y" ]; then
      echo "Operation cancelled."
      exit 1
    fi

    # Uninstall old versions
    sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)

    # -*- Set up the repository -*-

    # Add Docker's official GPG key:
    sudo apt update
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    sudo tee /etc/apt/sources.list.d/docker.sources << EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt update

    # -*- Install the Docker packages -*-

    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # -*- After installation, start the Docker service -*-

    sudo systemctl start docker

    # Continue to Post-installation steps for Linux - https://docs.docker.com/engine/install/linux-postinstall/

    # -*- Manage Docker as a non-root user -*-
    # If you don’t want to preface the docker command with sudo, create a Unix group called docker and add users to it.
    # When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group.

    sudo groupadd docker

    sudo usermod -aG docker $USER

    echo "---> Log out and log back in so that your group membership is re-evaluated."

    read -p "Docker was installed. Press any key to continue ..."

    # Verify that the installation is successful by running the hello-world image:
    # docker run hello-world

  fi

  if [ "$1" == "create" ]; then

    # Verify that Docker Engine is installed correctly by running the hello-world image.
    echo "---> Create a container"
    # https://docs.docker.com/engine/reference/commandline/run/
    docker run --name hw1 hello-world

    echo "---> Start an existing container"
    # https://docs.docker.com/engine/reference/commandline/start/
    docker start --attach --interactive hw1

  fi

  if [ "$1" == "status" ]; then
    systemctl is-active --quiet docker || systemctl start docker
    echo "---> Docker service is..."
    systemctl is-active docker

    read -t 5 -p "Do you want to see full status info? (Y/N) [Default: n]: " answer
    if [ "${answer,,}" == "y" ]; then
      systemctl status docker
      exit 0
    else
      echo "Skipping full status info."
    fi

  fi

  if [ "$1" == "remove_all" ]; then

    echo "---> Remove all containers, images, volumes and networks"
    read -p "Are you sure you want to proceed? (Y/N): " answer
    if [ "${answer,,}" != "y" ]; then
      echo "Operation cancelled."
      exit 1
    fi

    echo "---> Stop all running containers"
    docker stop $(docker ps -a -q)

    echo "---> Remove all stopped containers"
    docker container prune --force

    echo "---> Remove all unused images"
    docker image prune ---all --force

    echo "---> Remove all local volumes not used by at least one container."
    docker volume prune --all --force

    echo "---> Remove all unused networks not used by at least one container."
    # [LEGACY METHOD] docker rmi $(docker images -f "dangling=true" -q)
    docker system prune --all --force

  fi

  if [ "$1" == "uninstall" ]; then
    echo "---> Uninstall Docker Engine, CLI, and Containerd packages."
    read -p "Are you sure you want to proceed? (Y/N): " answer
    if [ "${answer,,}" != "y" ]; then
      echo "Operation cancelled."
      exit 1
    fi

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

  if [ "$1" == "list" ]; then

    echo "---> See a list of all containers, even the ones not running"
    docker ps -a

    echo "---> Show all images on this machine"
    docker images -a

    echo "---> Show all volumes on this machine"
    docker volume ls

    echo "---> Show all networks on this machine"
    docker network ls

  fi

  if [ "$1" == "update" ]; then

    echo "---> Update all locally cached Docker images to their latest versions by pulling them again from their respective remote registries"
    docker images --format "{{.Repository}}:{{.Tag}}" | xargs -L1 docker pull

    echo "---> Show all the dangling images (untagged images)"
    docker images -f "dangling=true" -q

  fi

else
  echo 'This script is only for Linux.'
fi
