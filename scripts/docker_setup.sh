#!/usr/bin/env bash

# ==============================================================================
# Docker Engine Management Script for Ubuntu
# Documentation: https://docs.docker.com/engine/install/ubuntu/
# Data Path (Linux): /var/lib/docker/
# ==============================================================================

# Shell safety settings: exit on unhandled errors, unbound variables, and pipe failures
set -euo pipefail

# Prevent running as root directly (script uses sudo where needed)
if [ "$(id -u)" -eq 0 ]; then
  echo "[ERROR] Do not run this script as root directly. Run as a regular user with sudo privileges." >&2
  exit 1
fi

# Ensure target platform is Linux
if [ "$(uname -s)" != "Linux" ]; then
  echo "[ERROR] This script is intended only for Linux systems." >&2
  exit 1
fi

# Helper function for user confirmations
confirm_action() {
  local prompt_message="${1:-Are you sure you want to proceed?}"
  read -r -p "${prompt_message} [y/N]: " answer
  case "${answer,,}" in
    y | yes) return 0 ;;
    *)
      echo "[INFO] Operation cancelled by user."
      exit 0
      ;;
  esac
}

# Print usage instructions
show_usage() {
  cat << EOF
Docker CLI Wrapper Utility (docker_setup.sh)

Usage: $(basename "$0") <command>

The following commands are available:
  install      Install Docker Engine and configure official repositories
  create       Create and run a sample verification container
  status       Display the current operational status of the Docker service
  list         Display detailed inventory (containers, images, volumes, networks, disk usage)
  update       Pull the latest tags for all local Docker images
  remove_all   Stop and remove all containers, unused images, volumes, and networks
  uninstall    Completely purge Docker Engine, packages, and residual state data

EOF
}

# Main command handling
COMMAND="${1:-}"

case "${COMMAND}" in
  install)
    echo "[INFO] Starting Docker Engine installation for Ubuntu..."
    confirm_action "Proceed with Docker Engine installation?"

    echo "[INFO] Removing conflicting legacy packages..."
    sudo apt-get remove -y docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc 2> /dev/null || true

    echo "[INFO] Setting up Docker APT repository and GPG key..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null << EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    echo "[INFO] Installing Docker Engine, CLI, Containerd, and modern plugins..."
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "[INFO] Enabling and starting Docker service..."
    sudo systemctl enable --now docker

    echo "[INFO] Managing Docker permissions for non-root execution..."
    if ! getent group docker > /dev/null; then
      sudo groupadd docker
    fi
    sudo usermod -aG docker "$USER"

    echo ""
    echo "[SUCCESS] Docker Engine installed successfully."
    echo "[NOTICE] Group membership updated. Log out and back in (or run 'newgrp docker') to apply changes without sudo."
    ;;

  create)
    echo "[INFO] Deploying test container..."
    docker run --name hw1 hello-world

    echo "[INFO] Interactively attaching to existing container 'hw1'..."
    docker start --attach --interactive hw1
    ;;

  status)
    echo "[INFO] Checking Docker service status..."
    if systemctl is-active --quiet docker; then
      echo "[STATUS] Docker daemon is running."
    else
      echo "[STATUS] Docker daemon is inactive. Starting service..."
      sudo systemctl start docker
    fi

    read -r -t 5 -p "Display detailed systemctl status output? [y/N]: " answer || true
    if [[ "${answer,,}" =~ ^(y|yes)$ ]]; then
      systemctl status docker
    else
      echo "[INFO] Skipped full status output."
    fi
    ;;

  list)
    echo "=== Active and Stopped Containers ==="
    docker ps --all

    echo -e "\n=== Local Docker Images ==="
    docker images --all

    echo -e "\n=== Dangling (Untagged) Images ==="
    docker images --filter "dangling=true"

    echo -e "\n=== Managed Volumes ==="
    docker volume ls

    echo -e "\n=== Configured Networks ==="
    docker network ls

    echo -e "\n=== Disk Space Consumption ==="
    docker system df

    echo ""
    read -r -t 5 -p "Display detailed Docker system information? [y/N]: " answer || true
    if [[ "${answer,,}" =~ ^(y|yes)$ ]]; then
      docker system info
    else
      echo "[INFO] Skipped system info."
    fi
    ;;

  update)
    echo "[INFO] Updating all local Docker images to their latest tags..."
    images=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>")
    if [ -n "$images" ]; then
      echo "$images" | xargs -L1 docker pull
      echo "[SUCCESS] Local images successfully updated."

      echo ""
      # Find dangling images older than 24 hours to match the prune filter
      dangling_images=$(docker images -f "dangling=true" -f "until=24h" -q)

      if [ -n "$dangling_images" ]; then
        echo "---> Dangling images found (older than 24h):"
        echo "$dangling_images"
        echo ""
        echo "---> Pruning dangling images older than 24 hours..."
        docker image prune --filter "until=24h" -f
      else
        echo "[INFO] No dangling or unused images found (older than 24h). Skipping prune."
      fi

    else
      echo "[INFO] No local images found to update."
    fi
    ;;

  remove_all)
    echo "[WARNING] This action stops and destroys ALL containers, images, volumes, and networks."
    confirm_action "Are you sure you want to wipe all local Docker assets?"

    echo "[INFO] Stopping active containers..."
    containers=$(docker ps -q)
    if [ -n "$containers" ]; then
      docker stop $containers
    fi

    echo "[INFO] Performing full system prune (containers, images, volumes, networks)..."
    docker system prune --all --volumes --force
    echo "[SUCCESS] All non-essential Docker assets purged."
    ;;

  uninstall)
    echo "[WARNING] This action completely removes Docker Engine, configurations, and state files."
    confirm_action "Are you sure you want to uninstall Docker?"

    echo "[INFO] Purging Docker packages..."
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

    echo "[INFO] Removing residual Docker configurations and state directories..."
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    sudo rm -f /etc/apt/sources.list.d/docker.sources
    sudo rm -f /etc/apt/keyrings/docker.asc

    if getent group docker > /dev/null; then
      echo "[INFO] Removing 'docker' group..."
      sudo groupdel docker
    fi

    echo "[SUCCESS] Docker successfully uninstalled from the system."
    ;;

  *)
    show_usage
    exit 1
    ;;
esac
