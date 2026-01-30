#!/usr/bin/env bash
# ============================================================
#  Application Node Provisioning Script
#  Role: Web Server (Nginx)
#  Maintainer: AliReza (Noyan Lab)
# ============================================================

set -e

echo "========== [Noyan App] Starting Application Node setup =========="

# --- Install Nginx ---
echo "[INFO] Installing Nginx..."
sudo apt-get update -y
sudo apt-get install -y nginx

# --- Enable and start Nginx ---
sudo systemctl enable nginx
sudo systemctl start nginx

# --- Verify service status ---
systemctl is-active --quiet nginx && echo "[INFO] Nginx is running."

# --- Create application directory ---
APP_DIR="/var/www/noyan-app"

if [ ! -d "$APP_DIR" ]; then
    sudo mkdir -p "$APP_DIR"
    sudo chown -R www-data:www-data "$APP_DIR"
    sudo chmod -R 755 "$APP_DIR"
fi

# --- Create a simple index page ---
INDEX_FILE="$APP_DIR/index.html"

if [ ! -f "$INDEX_FILE" ]; then
cat <<EOF | sudo tee "$INDEX_FILE"
<!DOCTYPE html>
<html>
<head>
  <title>Noyan App Node</title>
</head>
<body>
  <h1>Noyan DevOps Lab</h1>
  <p>Application node is up and running.</p>
</body>
</html>
EOF
fi

# --- Configure default Nginx site ---
NGINX_SITE="/etc/nginx/sites-available/noyan-app"

if [ ! -f "$NGINX_SITE" ]; then
cat <<EOF | sudo tee "$NGINX_SITE"
server {
    listen 80;
    server_name _;

    root $APP_DIR;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

    sudo ln -s "$NGINX_SITE" /etc/nginx/sites-enabled/noyan-app
    sudo rm -f /etc/nginx/sites-enabled/default
fi

# --- Reload Nginx configuration ---
sudo nginx -t
sudo systemctl reload nginx

echo "========== [Noyan App] Application Node setup completed =========="