#!/usr/bin/env bash
# ============================================================
#  Common Provisioning Script for all Noyan_* VMs (Iran‑Friendly)
#  Maintainer: AliReza (Noyan Lab)
# ============================================================

set -e  # Exit on error

echo "========== [Noyan Provisioning] Starting common setup =========="

# --- Backup original sources.list and set mirrors ---
if [ -f /etc/apt/sources.list ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d)
fi

# Set to Debian/Ubuntu mirrors (adjust if using a different base)
# For Ubuntu 22.04 (jammy)
#cat <<EOF | sudo tee /etc/apt/sources.list
#deb http://mirror.iranrepo.ir/ubuntu/ jammy main restricted universe multiverse
#deb http://mirror.iranrepo.ir/ubuntu/ jammy-updates main restricted universe multiverse
#deb http://mirror.iranrepo.ir/ubuntu/ jammy-security main restricted universe multiverse
#EOF

# --- Update (without upgrade) ---
sudo apt-get update -y
# sudo apt-get upgrade -y   # Commented out to keep version controlled

# --- Install fundamental packages ---
sudo apt-get install -y curl wget vim git net-tools htop unzip software-properties-common

# --- Set timezone (Asia/Tehran) ---
sudo timedatectl set-timezone Asia/Tehran

# --- Configure NTP with servers ---
sudo apt-get install -y chrony
cat <<EOF | sudo tee /etc/chrony/chrony.conf
# NTP servers
server ntp.ir  iburst
server time.ir iburst
pool pool.ntp.org iburst

# Allow NTP client access from local network
allow 192.168.56.0/24

# Increase polling interval for stability
minpoll 4
maxpoll 16

# Enable kernel RTC synchronization
rtcsync
EOF

sudo systemctl restart chrony
sudo systemctl enable chrony
sudo timedatectl set-ntp true

# --- Add a standard non‑root user ---
USER_NAME="devops"

if id "$USER_NAME" &>/dev/null; then
    echo "User '$USER_NAME' already exists. Skipping..."
else
    sudo adduser --disabled-password --gecos "" "$USER_NAME"
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER_NAME
    sudo chmod 0440 /etc/sudoers.d/$USER_NAME
    echo "User '$USER_NAME' created and added to sudoers."
fi

# --- Add convenience aliases ---
BASHRC="/home/$USER_NAME/.bashrc"
if ! grep -q "alias ll='ls -la --color=auto'" "$BASHRC"; then
    echo "alias ll='ls -la --color=auto'" | sudo tee -a "$BASHRC"
    echo "alias l='ls -CF'" | sudo tee -a "$BASHRC"
fi

# --- Optional: Create a data partition (if you add a second disk in Vagrantfile) ---
# Uncomment and adjust if you attach an extra disk (e.g., /dev/sdb)
# DATA_MOUNT="/mnt/data"
# if [ -b /dev/sdb ] && ! mount | grep -q "$DATA_MOUNT"; then
#     sudo mkfs.ext4 -F /dev/sdb
#     sudo mkdir -p $DATA_MOUNT
#     sudo mount /dev/sdb $DATA_MOUNT
#     echo "/dev/sdb  $DATA_MOUNT  ext4  defaults  0  2" | sudo tee -a /etc/fstab
#     echo "Extra disk mounted at $DATA_MOUNT"
# fi

# --- Clean‑up to reduce box size ---
sudo apt-get autoremove -y
sudo apt-get clean

echo "========== [Noyan Provisioning] Common setup completed =========="