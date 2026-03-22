#!/bin/bash
# First-time server setup for StoryWorlds MUD on Oracle Cloud (Ubuntu)
# Run as root: sudo bash setup-server.sh

set -e

echo "=== StoryWorlds Server Setup ==="

# Create service user
echo "[1/4] Creating storyworlds user..."
if ! id -u storyworlds &>/dev/null; then
    useradd --system --no-create-home --shell /usr/sbin/nologin storyworlds
    echo "  Created user: storyworlds"
else
    echo "  User already exists"
fi

# Create install directory
echo "[2/4] Setting up /opt/storyworlds..."
mkdir -p /opt/storyworlds
chown storyworlds:storyworlds /opt/storyworlds

# Open firewall ports (Oracle Ubuntu uses iptables by default)
echo "[3/4] Opening firewall ports..."
# Check if iptables rules already exist
if ! iptables -C INPUT -p tcp --dport 33333 -j ACCEPT 2>/dev/null; then
    iptables -I INPUT 6 -p tcp --dport 33333 -j ACCEPT
    echo "  Opened port 33333 (telnet)"
fi
if ! iptables -C INPUT -p tcp --dport 80 -j ACCEPT 2>/dev/null; then
    iptables -I INPUT 6 -p tcp --dport 80 -j ACCEPT
    echo "  Opened port 80 (web client)"
fi

# Save iptables rules to persist across reboots
if command -v netfilter-persistent &>/dev/null; then
    netfilter-persistent save
else
    echo "  Installing iptables-persistent..."
    apt-get update -qq && apt-get install -y -qq iptables-persistent
    netfilter-persistent save
fi

# Install systemd service
echo "[4/4] Installing systemd service..."
cp /opt/storyworlds/storyworlds.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable storyworlds

echo ""
echo "=== Setup complete! ==="
echo "Next steps:"
echo "  1. Upload the game files: scp deploy-bundle.tar.gz user@server:/tmp/"
echo "  2. Extract: sudo tar xzf /tmp/deploy-bundle.tar.gz -C /opt/storyworlds/"
echo "  3. Fix ownership: sudo chown -R storyworlds:storyworlds /opt/storyworlds"
echo "  4. Start: sudo systemctl start storyworlds"
echo "  5. Check: sudo systemctl status storyworlds"
echo "  6. Logs: sudo journalctl -u storyworlds -f"
