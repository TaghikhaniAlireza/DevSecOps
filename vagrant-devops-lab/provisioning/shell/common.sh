#!/bin/bash
# ============================================================
#  Common Provisioning Script for all Noyan_* VMs
#  Maintainer: AliReza (Noyan Lab)
# ============================================================

set -e  # Exit on error

echo "========== [Noyan Provisioning] Starting common setup =========="

# --- Update and basic tools ---
sudo apt-get update -y
#sudo apt-get upgrade -y

# --- Install fundamental packages ---
sudo apt-get install -y curl wget vim git net-tools htop unzip software-properties-common

# --- Set timezone (adjust if needed) ---
sudo timedatectl set-timezone Asia/Tehran

# --- Add a standard non-root user ---
USER_NAME="devops"

if id "$USER_NAME" &>/dev/null; then
    echo "User '$USER_NAME' already exists. Skipping..."
else
    sudo adduser --disabled-password --gecos "" "$USER_NAME"
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER_NAME
    echo "User '$USER_NAME' created and added to sudoers."
fi

# --- Add convenience Aliases ---
BASHRC="/home/$USER_NAME/.bashrc"
if ! grep -q "alias ll='ls -la --color=auto'" "$BASHRC"; then
    echo "alias ll='ls -la --color=auto'" | sudo tee -a "$BASHRC"
fi

# --- Clean-up to reduce box size ---
sudo apt-get autoremove -y
sudo apt-get clean

echo "========== [Noyan Provisioning] Common setup completed ✅ =========="
