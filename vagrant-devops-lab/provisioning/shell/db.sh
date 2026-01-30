#!/usr/bin/env bash
# ============================================================
#  Database Node Provisioning Script
#  Role: PostgreSQL Database Server
#  Maintainer: AliReza (Noyan Lab)
# ============================================================

set -e

echo "========== [Noyan DB] Starting Database Node setup =========="

DB_NAME="noyan_db"
DB_USER="noyan_user"
DB_PASSWORD="noyan_password"
DB_BIND_IP="192.168.56.12"

# --- Install PostgreSQL ---
echo "[INFO] Installing PostgreSQL..."
sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib

# --- Enable and start PostgreSQL ---
sudo systemctl enable postgresql
sudo systemctl start postgresql

# --- Configure PostgreSQL to listen on private IP only ---
PG_CONF="/etc/postgresql/14/main/postgresql.conf"
PG_HBA="/etc/postgresql/14/main/pg_hba.conf"

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '$DB_BIND_IP'/" $PG_CONF

# --- Allow App node access ---
if ! grep -q "192.168.56.11" $PG_HBA; then
    echo "host    all     all     192.168.56.11/32    md5" | sudo tee -a $PG_HBA
fi

# --- Restart PostgreSQL ---
sudo systemctl restart postgresql

# --- Create database and user (idempotent) ---
sudo -u postgres psql <<EOF
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME') THEN
      CREATE DATABASE $DB_NAME;
   END IF;
END
\$\$;

DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$DB_USER') THEN
      CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
   END IF;
END
\$\$;

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF

echo "========== [Noyan DB] Database Node setup completed =========="