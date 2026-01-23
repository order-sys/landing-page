#!/usr/bin/env bash
set -e

DOMAIN="syrianorder.com"
SITE_DIR="/var/www/landing-page"
NGINX_SITE="/etc/nginx/sites-available/$DOMAIN"

echo "🔹 Installing required packages..."
sudo apt update
sudo apt install -y nginx rsync

echo "🔹 Creating web root..."
sudo mkdir -p "$SITE_DIR"

echo "🔹 Deploying static website..."
sudo rsync -av --delete \
  --exclude .git \
  --exclude .idea \
  --exclude .netlify \
  --exclude nginx \
  --exclude deploy.sh \
  ./ "$SITE_DIR/"

sudo chown -R www-data:www-data "$SITE_DIR"
sudo chmod -R 755 "$SITE_DIR"

echo "🔹 Installing nginx config..."
sudo cp "nginx/$DOMAIN.conf" "$NGINX_SITE"

echo "🔹 Enabling nginx site..."
sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s "$NGINX_SITE" "/etc/nginx/sites-enabled/$DOMAIN"

echo "🔹 Testing nginx configuration..."
sudo nginx -t

echo "🔹 Reloading nginx..."
sudo systemctl reload nginx

echo "✅ Deployment complete!"
