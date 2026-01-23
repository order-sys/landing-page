#!/usr/bin/env bash
set -e

DOMAIN="syrianorder.com"
SITE_DIR="/var/www/landing-page"
NGINX_SITE="/etc/nginx/sites-available/$DOMAIN"

echo "🔹 Installing nginx..."
sudo apt update
sudo apt install -y nginx rsync

echo "🔹 Creating web root..."
sudo mkdir -p $SITE_DIR

echo "🔹 Deploying static files..."
sudo rsync -av --delete ./ $SITE_DIR \
  --exclude .git \
  --exclude nginx \
  --exclude deploy.sh

sudo chown -R www-data:www-data $SITE_DIR
sudo chmod -R 755 $SITE_DIR

echo "🔹 Installing nginx config..."
sudo cp nginx/$DOMAIN.conf $NGINX_SITE

echo "🔹 Enabling site..."
sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s $NGINX_SITE /etc/nginx/sites-enabled/$DOMAIN

echo "🔹 Testing nginx config..."
sudo nginx -t

echo "🔹 Reloading nginx..."
sudo systemctl reload nginx

echo "✅ Deployment complete!"
