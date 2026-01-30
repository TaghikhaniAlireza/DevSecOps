#!/usr/bin/env bash
# ============================================================
#  SSH Bootstrap for Ansible (As-a-Code)
#  Control -> App / DB
# ============================================================

set -e

echo "========== [Noyan Control] SSH bootstrap starting =========="

CONTROL_USER="devops"
CONTROL_HOME="/home/$CONTROL_USER"
SSH_DIR="$CONTROL_HOME/.ssh"
KEY_FILE="$SSH_DIR/id_rsa"
PUB_KEY="$KEY_FILE.pub"

TARGET_USER="vagrant"
TARGET_PASS="vagrant"
TARGETS=("192.168.56.11" "192.168.56.12")

# ------------------------------------------------------------
# Ensure devops user exists on control
# ------------------------------------------------------------
if ! id "$CONTROL_USER" &>/dev/null; then
  sudo adduser --disabled-password --gecos "" "$CONTROL_USER"
  echo "$CONTROL_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$CONTROL_USER
fi

# ------------------------------------------------------------
# SSH key for devops (control)
# ------------------------------------------------------------
sudo -u "$CONTROL_USER" mkdir -p "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"

if [ ! -f "$KEY_FILE" ]; then
  sudo -u "$CONTROL_USER" ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" -N ""
fi

# ------------------------------------------------------------
# known_hosts
# ------------------------------------------------------------
for host in 192.168.56.10 "${TARGETS[@]}"; do
  sudo -u "$CONTROL_USER" ssh-keyscan -H "$host" >> "$SSH_DIR/known_hosts" 2>/dev/null || true
done

sudo chown -R "$CONTROL_USER:$CONTROL_USER" "$SSH_DIR"
sudo chmod 600 "$SSH_DIR/known_hosts"

# ------------------------------------------------------------
# Bootstrap App & DB via sshpass (initial access)
# ------------------------------------------------------------
for TARGET in "${TARGETS[@]}"; do
  echo "[INFO] Bootstrapping $TARGET"

  sshpass -p "$TARGET_PASS" ssh \
    -o PreferredAuthentications=password \
    -o PubkeyAuthentication=no \
    -o StrictHostKeyChecking=no \
    "$TARGET_USER@$TARGET" <<EOF
sudo adduser --disabled-password --gecos "" devops || true
echo 'devops ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/devops

sudo mkdir -p /home/devops/.ssh
sudo chmod 700 /home/devops/.ssh

sudo tee /home/devops/.ssh/authorized_keys > /dev/null <<KEY
$(cat "$PUB_KEY")
KEY

sudo chown -R devops:devops /home/devops/.ssh
sudo chmod 600 /home/devops/.ssh/authorized_keys
EOF

done

# ------------------------------------------------------------
# Ansible Inventory
# ------------------------------------------------------------
ANSIBLE_DIR="$CONTROL_HOME/ansible"
INVENTORY="$ANSIBLE_DIR/inventory/hosts.ini"

sudo mkdir -p "$ANSIBLE_DIR/inventory"

cat <<EOF | sudo tee "$INVENTORY"
[noyan_control]
192.168.56.10 ansible_user=devops ansible_ssh_private_key_file=$KEY_FILE

[noyan_app]
192.168.56.11 ansible_user=devops ansible_ssh_private_key_file=$KEY_FILE

[noyan_db]
192.168.56.12 ansible_user=devops ansible_ssh_private_key_file=$KEY_FILE
EOF

sudo chown -R "$CONTROL_USER:$CONTROL_USER" "$ANSIBLE_DIR"

echo "========== SSH bootstrap completed successfully =========="