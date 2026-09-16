#!/usr/bin/env bash

# Shell safety settings: exit on unhandled errors, unbound variables, and pipe failures
set -euo pipefail

# Ensure the script runs strictly on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
  echo "[ERROR] This script is supported only on Linux distributions." >&2
  exit 1
fi

SCRIPT_NAME="$(basename "$0")"
COMMAND="${1:-}"
PARAM="${2:-}"

# Display usage instructions
show_usage() {
  cat << EOF
Usage: $SCRIPT_NAME <command> [option]

Commands:
  install, i             Install core development utilities and archive tools.
  update, u              Update repository indexes and upgrade all system packages.
  list, l [installed|u]  List packages. Use 'installed' (or 'i', default) or 'upgradeable' (or 'u').
  autoremove, r          Autoremove unused packages and purge residual configuration files.
  search, s <pattern>    Search installed packages using a pattern.
EOF
}

case "$COMMAND" in
  "update" | "u")
    echo "[INFO] Updating package lists and upgrading system packages..."
    sudo apt update -y
    sudo apt upgrade -y
    ;;

  "install" | "i")
    echo "[INFO] Installing standard system utilities..."
    sudo apt update -y
    sudo apt install -y build-essential zip unzip unrar
    ;;

  "list" | "l")
    case "$PARAM" in
      "" | "installed" | "i")
        echo "[INFO] Listing installed packages..."
        apt list --installed
        ;;
      "upgradeable" | "u")
        echo "[INFO] Listing upgradeable packages..."
        apt list --upgradeable
        ;;
      *)
        echo "[ERROR] Invalid option '$PARAM' for listing. Use 'installed' (i) or 'upgradeable' (u)." >&2
        exit 1
        ;;
    esac
    ;;

  "search" | "s")
    if [[ -z "$PARAM" ]]; then
      echo "[ERROR] Missing search pattern." >&2
      echo "Example: $SCRIPT_NAME search zip" >&2
      exit 1
    fi
    echo "[INFO] Searching installed packages matching pattern: '$PARAM'"
    dpkg-query -l "*${PARAM}*" | grep -v '^un' || echo "[INFO] No matching packages found."
    ;;

  "autoremove" | "remove" | "r")
    echo "[INFO] Removing unused packages and purging residual configuration..."
    sudo apt autoremove -y

    # Purge remaining configuration files ('rc' state) cleanly
    REMOVED_CONFIGS=$(dpkg -l | awk '/^rc/ {print $2}')
    if [[ -n "$REMOVED_CONFIGS" ]]; then
      echo "$REMOVED_CONFIGS" | xargs -r sudo apt-get purge -y
    else
      echo "[INFO] No residual configuration files found."
    fi
    ;;

  "")
    echo "[ERROR] No command specified." >&2
    show_usage
    exit 1
    ;;

  *)
    echo "[ERROR] Unrecognized command '$COMMAND'." >&2
    show_usage
    exit 1
    ;;
esac
