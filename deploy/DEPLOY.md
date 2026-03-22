# Deploying StoryWorlds MUD to Oracle Cloud

## Part 1: Create Oracle Cloud Account

1. Go to https://cloud.oracle.com/free and sign up
2. You'll need a credit card for verification (you won't be charged)
3. Choose a **Home Region** close to you (e.g., US East - Ashburn, US West - Phoenix)
4. Wait for account activation (usually a few minutes)

## Part 2: Create the VM Instance

1. Log into Oracle Cloud Console
2. Go to **Compute > Instances > Create Instance**
3. Configure:
   - **Name:** `storyworlds`
   - **Image:** Ubuntu 22.04 (or 24.04)
   - **Shape:** Click "Change Shape" > **Ampere** > **VM.Standard.A1.Flex**
     - OCPUs: **1** (free tier allows up to 4)
     - Memory: **6 GB** (free tier allows up to 24)
   - **Networking:** Use the default VCN, or create one. Ensure "Assign public IPv4" is checked
   - **SSH Key:** Either generate a key pair (download the private key!) or paste your existing public key
4. Click **Create**
5. Wait for the instance to be **Running** — note the **Public IP Address**

> **If you get "Out of Capacity"**: ARM instances are in high demand. Try a different availability domain, or wait and retry. Some regions have better availability than others.

## Part 3: Open Firewall Ports (Oracle Cloud Security List)

Oracle has TWO firewalls: the cloud security list AND the OS firewall. You must open both.

### Cloud Security List:
1. Go to **Networking > Virtual Cloud Networks** > click your VCN
2. Click the **subnet** > click the **Security List**
3. Add **Ingress Rules**:

| Source CIDR | Protocol | Dest Port | Description |
|-------------|----------|-----------|-------------|
| 0.0.0.0/0   | TCP      | 33333     | MUD Telnet  |
| 0.0.0.0/0   | TCP      | 80        | Web Client  |

(Port 22 for SSH should already be open)

## Part 4: First-Time Server Setup

SSH into your new instance:
```bash
ssh -i /path/to/your/private-key ubuntu@YOUR_PUBLIC_IP
```

Upload and run the setup script:
```bash
# From your local machine:
scp -i /path/to/key deploy/setup-server.sh ubuntu@YOUR_PUBLIC_IP:/tmp/

# On the server:
sudo bash /tmp/setup-server.sh
```

This creates the `storyworlds` user, opens OS firewall ports, and installs the systemd service.

## Part 5: Build and Deploy

From your local machine (in the project root):
```bash
# Build and upload in one step:
./deploy/deploy.sh ubuntu@YOUR_PUBLIC_IP /path/to/your/private-key

# Or just build:
./deploy/deploy.sh
# Then manually upload deploy/deploy-bundle.tar.gz
```

Then on the server:
```bash
sudo tar xzf /tmp/deploy-bundle.tar.gz -C /opt/storyworlds/
sudo chown -R storyworlds:storyworlds /opt/storyworlds
sudo systemctl start storyworlds
```

## Part 6: Verify

```bash
# Check service status:
sudo systemctl status storyworlds

# Watch logs:
sudo journalctl -u storyworlds -f

# Test telnet locally on the server:
telnet localhost 33333
```

From your local machine:
- **Telnet:** `telnet YOUR_PUBLIC_IP 33333`
- **Web Client:** Open `http://YOUR_PUBLIC_IP` in a browser
- **Login:** username `admin`, password is the one that was generated

## Updating the Server

After making changes locally:
```bash
./deploy/deploy.sh ubuntu@YOUR_PUBLIC_IP /path/to/key
ssh -i /path/to/key ubuntu@YOUR_PUBLIC_IP
sudo tar xzf /tmp/deploy-bundle.tar.gz -C /opt/storyworlds/
sudo chown -R storyworlds:storyworlds /opt/storyworlds
sudo systemctl restart storyworlds
```

## Troubleshooting

**Can't connect on port 33333 or 80:**
- Check Oracle Cloud Security List (ingress rules)
- Check OS firewall: `sudo iptables -L INPUT -n` (should show ACCEPT for 33333 and 80)
- Check service is running: `sudo systemctl status storyworlds`

**Service won't start:**
- Check logs: `sudo journalctl -u storyworlds -e`
- Check file permissions: `ls -la /opt/storyworlds/`
- Ensure config.yaml exists: `cat /opt/storyworlds/config.yaml`

**"Out of Capacity" when creating instance:**
- Try a different availability domain in the same region
- Try again later (ARM instances are popular)
- Switch to a different home region if you haven't created other resources
