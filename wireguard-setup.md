# WireGuard Setup (Existing Configuration)

## 1. Install WireGuard

```bash
# Ubuntu/Debian
sudo apt install wireguard

# Arch Linux
sudo pacman -S wireguard-tools
```

## 2. Copy Configuration File

```bash
sudo cp wg0.conf /etc/wireguard/wg0.conf
sudo chmod 600 /etc/wireguard/wg0.conf
```

## 3. Enable and Start the Service

```bash
# Start immediately
sudo wg-quick up wg0

# Enable to start on boot
sudo systemctl enable wg-quick@wg0

# Verify it's running
sudo systemctl status wg-quick@wg0
wg show
```

## 4. Stop/Disable (if needed)

```bash
sudo wg-quick down wg0
sudo systemctl disable wg-quick@wg0
```

---

## Quick Reference

| Step | Command |
|------|---------|
| Install (Ubuntu) | `sudo apt install wireguard` |
| Install (Arch) | `sudo pacman -S wireguard-tools` |
| Copy config | `sudo cp wg0.conf /etc/wireguard/wg0.conf` |
| Secure config | `sudo chmod 600 /etc/wireguard/wg0.conf` |
| Start VPN | `sudo wg-quick up wg0` |
| Enable on boot | `sudo systemctl enable wg-quick@wg0` |
| Check status | `sudo systemctl status wg-quick@wg0` |
| Show interface | `wg show` |
| Stop VPN | `sudo wg-quick down wg0` |
| Disable on boot | `sudo systemctl disable wg-quick@wg0` |
