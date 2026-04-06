# Arch Linux AI Development Bootstrap

A set of scripts to bootstrap an Arch Linux environment after installation to enable AI development and AI inferencing.

## Overview

This repository contains three bootstrap scripts:

| Script | Purpose | Use Case |
|--------|---------|----------|
| `bootloader.sh` | GRUB EFI bootloader | Install after Arch base system, before `run.sh` |
| `run.sh` | Core system setup | Headless servers, dev machines, or base system |
| `desktop.sh` | Desktop environment | Optional KDE Plasma GUI installation |

## ⚠️ Prerequisites

**Before running these scripts, your Arch Linux installation must be at least:**

1. ✅ **Chrooted into the new root partition** - The scripts assume you're already inside your new Arch system
2. ✅ **Root password set** - `passwd` command already run for root user
3. ✅ **User account created** - At least one regular user with home directory and password set

### Why These Requirements?

| Requirement | Reason |
|-------------|--------|
| **Chrooted** | Scripts use `sudo`, modify `/etc/`, and install packages to the target system |
| **Root password** | Required for `sudo` commands throughout the scripts |
| **User account** | Scripts set up development tools in user home (`~/`, `$HOME`) |

### Basic Arch Installation Checklist

Before running `run.sh` or `desktop.sh`, ensure you've completed:

```bash
# Inside your chroot environment:
# 1. Set root password
passwd

# 2. Create a regular user
useradd -m -G wheel username
passwd username

# 3. Enable sudo for wheel group (optional but recommended)
EDITOR=nano visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL

# 4. Install and enable NetworkManager (for network access)
pacman -S networkmanager
systemctl enable NetworkManager

# 5. Verify you have internet access
ping -c 3 archlinux.org
```

---

## Quick Start

### Full Installation Order

```bash
# 1. Install Arch Linux base system first (official guide)
# 2. Install GRUB bootloader
curl -sL http://your-ip:8080/bootloader.sh | bash

# 3. Run the bootstrap script (with hostname argument)
curl -sL http://your-ip:8080/run.sh | bash

# Or clone the repository
cd ~/code/repos
git clone https://github.com/hermidev/ai-arch-bootstrap.git
cd ai-arch-bootstrap

# Run bootloader first (if needed)
./bootloader.sh

# Then run the bootstrap script
./run.sh my-hostname

# Optional: Install desktop environment
./desktop.sh
```

### Full Desktop Setup

```bash
# First, run the base bootstrap
./run.sh my-hostname

# Then install desktop environment (optional)
./desktop.sh

# Reboot to enter KDE Plasma
sudo reboot
```

## What `bootloader.sh` Installs (6 Steps)

1. **UEFI detection** - Verifies system is booted in UEFI mode
2. **GRUB + efibootmgr** - Installs bootloader and EFI tools
3. **EFI mount point** - Creates `/boot` directory if needed
4. **EFI partition mount** - Auto-detects and mounts EFI partition
5. **GRUB installation** - Installs GRUB to EFI system partition
6. **GRUB config** - Generates `/boot/grub/grub.cfg`

### Requirements

- **UEFI boot mode** (not BIOS/legacy)
- **EFI system partition** (usually `/dev/nvme0n1p1` or `/dev/sda1`)
- **Root access** (sudo)

### Usage

```bash
# Run directly
./bootloader.sh

# Or via curl
curl -sL http://your-ip:8080/bootloader.sh | bash
```

---

## What `run.sh` Installs (26 Steps)

### System & Network
1. **Hostname configuration** - Set system hostname (CLI arg or prompt)
2. **System updates** - Full package upgrade
3. **Base tools** - `base-devel`, `git`, `git-lfs`, `vim`, `curl`, `wget`
4. **OpenSSH server** - Enable SSH access (systemd enabled)
5. **NetworkManager** - WiFi/network management (systemd enabled)

### Audio & Connectivity
6. **PipeWire audio** - `pipewire`, `pipewire-pulse`, `wireplumber`, `pavucontrol`
7. **Bluetooth** - `bluez`, `bluez-utils` (systemd enabled)
8. **Firmware** - `linux-firmware` for WiFi/Bluetooth hardware

### Development Tools
9. **Shell utilities** - `tmux`, `btop`, `htop`, `bash-color-prompt` (colored PS1)
10. **Python tools** - `python-pip`, `python-venv`
11. **OpenCL** - `ocl-icd`, `opencl-icd-loader` for GPU compute
12. **Utilities** - `jq`, `wireguard-tools` for VPN

### Package Managers
13. **yay** - AUR helper (installed from source)

### Media & Graphics
14. **FFmpeg** - Video codecs (AV1, H.264, H.265, VP9)
15. **Vulkan SDK** - LunarG SDK 1.4.341.1
16. **Vulkan drivers** - AMD/Intel/NVIDIA support

### Language Runtimes
17. **Volta.sh** - Node.js version manager + Node LTS
18. **PyEnv** - Python version manager + Python 3.12.12

### AI Repositories
19. **Git LFS** - Large file support
20. **Directory structure** - `~/code/repos` created
21. **llama.cpp** - Cloned from ggerganov
22. **whisper.cpp** - Cloned from ggerganov

## What `desktop.sh` Installs (7 Steps)

1. **System updates** - Full package upgrade
2. **NetworkManager** - WiFi/network management (for standalone use)
3. **KDE Plasma** - `plasma-meta`, `kde-applications-meta`, `bluedevil`
4. **Firefox** - Web browser
5. **Flatpak** - Universal package manager + Flathub repo
6. **GPU drivers** - Auto-detects and installs Nvidia/AMD/Intel drivers
7. **SDDM** - Display manager (enabled for auto-login screen)

## Post-Install Configuration

### Git Setup (Required)
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### SSH Server (Auto-Started)
```bash
# SSH server is automatically started during bootstrap
# Check status if needed
systemctl status sshd
```

### Audio Configuration
```bash
# GUI audio mixer
pavucontrol

# Pair Bluetooth headset
bluetoothctl
  scan on
  pair XX:XX:XX:XX:XX:XX
  connect XX:XX:XX:XX:XX:XX
```

### Printer Setup
```bash
# GUI printer configuration
system-config-printer
```

## Package Installation After Bootstrap

Once the bootstrap is complete, install additional packages as needed:

```bash
# Official repos
sudo pacman -S discord slack-desktop code

# AUR packages
yay -S discord-bin visual-studio-code-bin

# Flatpak apps
flatpak install flathub com.spotify.Client
flatpak install flathub us.zoom.Zoom
```

## Hardware Support

| Component | Support |
|-----------|---------|
| **WiFi** | NetworkManager + linux-firmware |
| **Bluetooth** | bluez + bluedevil (GUI) |
| **Audio** | PipeWire + pavucontrol |
| **NVIDIA GPU** | Vulkan drivers, OpenCL, proprietary drivers (desktop.sh) |
| **AMD GPU** | Vulkan drivers (vulkan-radeon), OpenCL |
| **Intel GPU** | Vulkan drivers (vulkan-intel), OpenCL |
| **Printers** | CUPS + system-config-printer |
| **USB/External** | Auto-mount via UDisks2 |

## Troubleshooting

### SSH Not Starting
```bash
sudo systemctl start sshd
sudo systemctl status sshd
```

### Audio Not Working
```bash
# Check PipeWire services
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart audio services
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Bluetooth Not Pairing
```bash
# Check Bluetooth service
sudo systemctl status bluetooth

# Restart if needed
sudo systemctl restart bluetooth
```

### NetworkManager Issues
```bash
# Check service
sudo systemctl status NetworkManager

# Use terminal UI
sudo nmtui
```

### Package Not Found Errors
If you encounter "target not found" errors, the package names may have changed:

| Wrong | Correct |
|-------|---------|
| `NetworkManager` | `networkmanager` |
| `python-venv` | `python-virtualenv` |
| `vpx` | `libvpx` |
| `libaom` | `aom` |
| `librav1e` | `rav1e` |
| `lib32-mesa` | Requires `[multilib]` repo enabled |

### multilib Repository Not Enabled
For 32-bit packages (lib32-*), ensure multilib is enabled:

```bash
# Edit /etc/pacman.conf
sudo nano /etc/pacman.conf

# Find and uncomment:
[multilib]
Include = /etc/pacman.d/mirrorlist

# Update
sudo pacman -Sy
```

### Volta/PyEnv Not Found
If `volta` or `pyenv` commands not found after installation:

```bash
# For Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# For PyEnv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Add to ~/.bashrc for persistence
echo 'export VOLTA_HOME="$HOME/.volta"' >> ~/.bashrc
echo 'export PATH="$VOLTA_HOME/bin:$PATH"' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
```

### Desktop Not Starting After Reboot
```bash
# Check SDDM service
sudo systemctl status sddm

# Start if not running
sudo systemctl start sddm
sudo systemctl enable sddm
```

## License

MIT License - Feel free to use and modify for your own Arch Linux setups.
