#!/usr/bin/env bash
# ============================================================
#  Control Node Provisioning Script
#  Role: Ansible Control Node
#  Maintainer: AliReza (Noyan Lab)
# ============================================================

set -e

echo "========== [Noyan Control] Starting Control Node setup =========="

CONTROL_USER="devops"
HOME_DIR="/home/$CONTROL_USER"

# --- Install Ansible ---
echo "[INFO] Installing Ansible..."
sudo apt-get update -y
sudo apt-get install -y ansible

# --- Verify Ansible installation ---
ansible --version

# --- Prepare SSH directory for Ansible ---
SSH_DIR="$HOME_DIR/.ssh"

if [ ! -d "$SSH_DIR" ]; then
    sudo mkdir -p "$SSH_DIR"
    sudo chown $CONTROL_USER:$CONTROL_USER "$SSH_DIR"
    sudo chmod 700 "$SSH_DIR"
fi

# --- Generate SSH key for Ansible (idempotent) ---
KEY_FILE="$SSH_DIR/id_rsa"

if [ ! -f "$KEY_FILE" ]; then
    sudo -u $CONTROL_USER ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" -N ""
    echo "[INFO] SSH key generated for user $CONTROL_USER"
else
    echo "[INFO] SSH key already exists. Skipping key generation."
fi

# --- Create Ansible directories ---
ANSIBLE_DIR="$HOME_DIR/ansible"

for dir in inventory playbooks roles; do
    if [ ! -d "$ANSIBLE_DIR/$dir" ]; then
        sudo mkdir -p "$ANSIBLE_DIR/$dir"
    fi
done

sudo chown -R $CONTROL_USER:$CONTROL_USER "$ANSIBLE_DIR"

echo "========== [Noyan Control] Control Node setup completed =========="