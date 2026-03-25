#!/bin/bash
# Sync local changes to the public StoryWorlds server
# Usage: ./deploy/sync-server.sh
#
# Steps: push to GitHub, pull on server, rebuild, restart service

set -e

SERVER="storyworlds"
REMOTE_DIR="/home/ubuntu/gomud"

echo "=== StoryWorlds Sync ==="

# 1. Push local changes to GitHub
echo "[1/4] Pushing to GitHub..."
git push origin main 2>&1 || git push origin "$(git branch --show-current)" 2>&1

# 2. Pull on server
echo "[2/4] Pulling on server..."
ssh "$SERVER" "cd $REMOTE_DIR && git pull origin main"

# 3. Build on server
echo "[3/4] Building on server..."
ssh "$SERVER" "cd $REMOTE_DIR/engine && go build -o $REMOTE_DIR/GoMud ."

# 4. Restart service
echo "[4/4] Restarting service..."
ssh "$SERVER" "sudo systemctl restart storyworlds"

# Verify
echo ""
echo "Verifying..."
sleep 2
ssh "$SERVER" "sudo systemctl is-active storyworlds"

echo ""
echo "=== Sync complete! ==="
echo "Server: http://150.136.199.80/webclient"
