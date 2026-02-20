#!/bin/bash

# Define the root paths
HDD_ROOT="/mnt/hdd"
DOCKER_BASE="$HDD_ROOT/docker"
MEDIA_BASE="$HDD_ROOT/media"
COMPOSE_ROOT="$(pwd)" # Assuming you run this from your homelab repo folder

echo "🚀 Starting Homelab Directory Setup..."

# 1. Create Docker Config Directories
echo "📁 Creating Docker config folders..."
configs=(
    "jellyfin"
    "mangal"
    "kavita/config"
    "qbittorrent"
    "sonarr"
    "radarr"
    "prowlarr"
    "komga/config"
)

for dir in "${configs[@]}"; do
    mkdir -p "$DOCKER_BASE/$dir"
done

# 2. Create Media Directories
echo "📁 Creating Media folders..."
media_folders=(
    "Movies"
    "Shows"
    "manga"
    "downloads"
)

for folder in "${media_folders[@]}"; do
    mkdir -p "$MEDIA_BASE/$folder"
done

# 3. Create Local App Directories (AdGuard/Nginx)
echo "📁 Creating local repo-based folders..."
mkdir -p "$COMPOSE_ROOT/adguard/work" "$COMPOSE_ROOT/adguard/conf"
mkdir -p "$COMPOSE_ROOT/nginx/conf.d"

# 4. Set Permissions (The "Real IT" way)
echo "🔒 Setting permissions (PUID 1000, PGID 1000)..."

# Ensure the user 'shivam' (or whoever is 1000) owns these
sudo chown -R 1000:1000 "$HDD_ROOT"
sudo chown -R 1000:1000 "$COMPOSE_ROOT/adguard"
sudo chown -R 1000:1000 "$COMPOSE_ROOT/nginx"

# Set directory permissions to 755 (rwxr-xr-x) and files to 644 (rw-r--r--)
sudo find "$HDD_ROOT" -type d -exec chmod 755 {} +
sudo find "$HDD_ROOT" -type f -exec chmod 644 {} +

echo "✅ Setup complete! You can now run: docker compose up -d"
