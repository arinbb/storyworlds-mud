#!/bin/bash
# Build and deploy StoryWorlds MUD to a remote server
# Usage: ./deploy/deploy.sh [user@host] [ssh-key-path]
#
# Examples:
#   ./deploy/deploy.sh ubuntu@129.146.xx.xx ~/.ssh/oracle_key
#   ./deploy/deploy.sh                        # just build, don't upload

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/deploy/build"
REMOTE_HOST="${1:-}"
SSH_KEY="${2:-}"

echo "=== StoryWorlds MUD Deploy ==="
echo "Project: $PROJECT_DIR"

# Clean build dir
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Cross-compile for Linux
# Set ARCH=arm64 for Ampere A1, or amd64 for E2.1.Micro
ARCH="${ARCH:-amd64}"
echo "[1/4] Cross-compiling for linux/$ARCH..."
cd "$PROJECT_DIR/engine"
go generate 2>/dev/null || true
GOOS=linux GOARCH="$ARCH" CGO_ENABLED=0 go build -trimpath -o "$BUILD_DIR/storyworlds-server" .
echo "  Binary: $(ls -lh "$BUILD_DIR/storyworlds-server" | awk '{print $5}')"

# Copy data files
echo "[2/4] Copying data files..."
rsync -a --exclude='._*' --exclude='.DS_Store' --exclude='users/*' "$PROJECT_DIR/engine/_datafiles/" "$BUILD_DIR/_datafiles/"
# Copy admin user separately (has the updated password)
mkdir -p "$BUILD_DIR/_datafiles/world/storyworlds/users"
cp "$PROJECT_DIR/engine/_datafiles/world/storyworlds/users/1.yaml" "$BUILD_DIR/_datafiles/world/storyworlds/users/" 2>/dev/null || true
cp "$PROJECT_DIR/config.yaml" "$BUILD_DIR/config.yaml"
cp "$PROJECT_DIR/deploy/storyworlds.service" "$BUILD_DIR/storyworlds.service"
cp "$PROJECT_DIR/deploy/setup-server.sh" "$BUILD_DIR/setup-server.sh"

# Create tarball
echo "[3/4] Creating deployment bundle..."
cd "$BUILD_DIR"
tar czf "$PROJECT_DIR/deploy/deploy-bundle.tar.gz" \
    storyworlds-server \
    config.yaml \
    storyworlds.service \
    setup-server.sh \
    _datafiles/
BUNDLE_SIZE=$(ls -lh "$PROJECT_DIR/deploy/deploy-bundle.tar.gz" | awk '{print $5}')
echo "  Bundle: deploy/deploy-bundle.tar.gz ($BUNDLE_SIZE)"

# Upload if remote host provided
if [ -n "$REMOTE_HOST" ]; then
    echo "[4/4] Uploading to $REMOTE_HOST..."
    SSH_OPTS=""
    if [ -n "$SSH_KEY" ]; then
        SSH_OPTS="-i $SSH_KEY"
    fi

    scp $SSH_OPTS "$PROJECT_DIR/deploy/deploy-bundle.tar.gz" "$REMOTE_HOST:/tmp/"
    echo "  Uploaded. Now SSH in and run:"
    echo "    sudo tar xzf /tmp/deploy-bundle.tar.gz -C /opt/storyworlds/"
    echo "    sudo chown -R storyworlds:storyworlds /opt/storyworlds"
    echo "    sudo systemctl restart storyworlds"
else
    echo "[4/4] No remote host specified — bundle ready at deploy/deploy-bundle.tar.gz"
    echo ""
    echo "To deploy manually:"
    echo "  scp deploy/deploy-bundle.tar.gz user@server:/tmp/"
    echo "  ssh user@server"
    echo "  sudo tar xzf /tmp/deploy-bundle.tar.gz -C /opt/storyworlds/"
    echo "  sudo chown -R storyworlds:storyworlds /opt/storyworlds"
    echo "  sudo systemctl restart storyworlds"
fi

# Cleanup
rm -rf "$BUILD_DIR"

echo ""
echo "=== Done! ==="
