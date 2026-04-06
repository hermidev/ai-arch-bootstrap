#!/bin/bash
# Arch Linux AI Development Bootstrap Script
# This script sets up a minimal Arch Linux environment for AI development

set -e

echo "=== Arch Linux AI Development Bootstrap ==="
echo ""

# Step 1: Set hostname
echo "[1/13] Configuring system hostname..."
if [ -n "$1" ]; then
  HOSTNAME="$1"
  echo "  Using hostname from argument: $HOSTNAME"
else
  read -p "Enter hostname (or press Enter to skip): " HOSTNAME
  if [ -z "$HOSTNAME" ]; then
    echo "  Skipping hostname configuration."
    HOSTNAME=""
  fi
fi

if [ -n "$HOSTNAME" ]; then
  echo "$HOSTNAME" | sudo tee /etc/hostname > /dev/null
  echo "  Hostname set to: $HOSTNAME"
  echo "  Note: You may need to update /etc/hosts if it references the old hostname."
fi

# Step 2: System updates
echo "[2/13] Updating system packages..."
sudo pacman -Syu --noconfirm

# Step 3: Install base development tools
echo "[3/13] Installing base development packages..."
sudo pacman -S --noconfirm base-devel git git-lfs vim curl wget tk

# Step 4: Install and enable OpenSSH server
echo "[4/26] Installing and enabling OpenSSH server..."
sudo pacman -S --noconfirm openssh
sudo systemctl enable sshd
sudo systemctl start sshd
echo "  SSH server enabled and started."

# Step 5: Install and enable NetworkManager
echo "[5/26] Installing and enabling NetworkManager..."
sudo pacman -S --noconfirm networkmanager network-manager-applet
sudo systemctl enable NetworkManager
echo "  NetworkManager enabled. Start with: sudo systemctl start NetworkManager"
echo "  Use 'nmtui' for terminal UI or 'nm-connection-editor' for GUI."

# Step 6: Install audio stack (PipeWire)
echo "[6/26] Installing PipeWire audio stack..."
sudo pacman -S --noconfirm pipewire pipewire-pulse wireplumber pavucontrol
echo "  PipeWire installed with pavucontrol for GUI audio control."
echo "  Use 'pavucontrol' to manage input/output devices and volumes."

# Step 7: Install Bluetooth support (for headsets)
echo "[7/26] Installing Bluetooth stack..."
sudo pacman -S --noconfirm bluez bluez-utils
sudo systemctl enable bluetooth
echo "  Bluetooth installed. Use 'bluetoothctl' to pair devices."

# Step 8: Install firmware packages
echo "[8/26] Installing linux-firmware..."
sudo pacman -S --noconfirm linux-firmware
echo "  Firmware packages installed for WiFi/Bluetooth support."

# Step 9: Install shell utilities
echo "[9/26] Installing shell utilities (tmux, btop, htop)..."
sudo pacman -S --noconfirm tmux btop htop
echo "  tmux: Terminal multiplexer"
echo "  btop: Modern system monitor"
echo "  htop: Process viewer"

# Step 10: Install Python tools
echo "[10/26] Installing Python tools (pip, virtualenv)..."
sudo pacman -S --noconfirm python-pip python-virtualenv
echo "  pip and virtualenv available for Python package management."

# Step 11: Install OpenCL support
echo "[11/26] Installing OpenCL support..."
sudo pacman -S --noconfirm ocl-icd opencl-icd-loader
echo "  OpenCL ICD loaders installed for GPU compute."

# Step 12: Install utilities (jq, wireguard)
echo "[12/26] Installing utilities (jq, wireguard-tools)..."
sudo pacman -S --noconfirm jq wireguard-tools
echo "  jq: JSON processor"
echo "  wireguard-tools: WireGuard VPN utilities"

# Step 13: Install printer support (CUPS)
echo "[13/26] Installing printer support..."
sudo pacman -S --noconfirm cups system-config-printer
sudo systemctl enable cups
echo "  CUPS printing system installed and enabled."
echo "  Use 'system-config-printer' GUI to add printers."

# Step 14: Install media codecs (GStreamer)
echo "[14/26] Installing media codecs (GStreamer)..."
sudo pacman -S --noconfirm gstreamer gst-plugins-good gst-plugins-bad gst-plugins-ugly
echo "  GStreamer codecs installed for video/audio playback."
echo "  Enables Zoom/Teams screen sharing and media playback."

# Step 15: Install auto-mount support (UDisks2)
echo "[15/26] Installing auto-mount support (UDisks2)..."
sudo pacman -S --noconfirm udisks2
echo "  UDisks2 installed for auto-mounting USB drives and external disks."

# Step 16: Install screenshot tool (Spectacle)
echo "[16/26] Installing screenshot tool (Spectacle)..."
sudo pacman -S --noconfirm spectacle
echo "  Spectacle installed for screenshots and screen recording."

# Step 17: Install yay AUR helper
echo "[17/26] Installing yay AUR package manager..."
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

# Step 18: Install FFmpeg and video codecs
echo "[18/26] Installing FFmpeg and video codecs..."
sudo pacman -S --noconfirm ffmpeg ffmpeg4.4 \
  aom rav1e svt-av1 \
  x264 x265 libvpx

# Step 19: Install Vulkan SDK
echo "[19/26] Installing Vulkan SDK..."
mkdir -p "$HOME/Vulkan"
VULKAN_VERSION="1.4.341.1"
VULKAN_URL="https://sdk.lunarg.com/sdk/download/${VULKAN_VERSION}/linux/vulkansdk-linux-x86_64-${VULKAN_VERSION}.tar.xz"
curl -L -o "$HOME/Vulkan/vulkansdk.tar.xz" "$VULKAN_URL"
cd "$HOME/Vulkan"
tar -xf vulkansdk.tar.xz
rm vulkansdk.tar.xz
# Add Vulkan environment variables to bashrc
echo '' >> "$HOME/.bashrc"
echo '# Vulkan SDK Environment Variables' >> "$HOME/.bashrc"
echo "export VULKAN_SDK=\"$HOME/Vulkan/${VULKAN_VERSION}/x86_64\"" >> "$HOME/.bashrc"
echo 'export PATH="$VULKAN_SDK/bin:$PATH"' >> "$HOME/.bashrc"
echo 'export LD_LIBRARY_PATH="$VULKAN_SDK/lib:$LD_LIBRARY_PATH"' >> "$HOME/.bashrc"
echo 'export VK_ADD_LAYER_PATH="$VULKAN_SDK/share/vulkan/explicit_layer.d"' >> "$HOME/.bashrc"

# Step 20: Install Vulkan drivers (AMD/Intel/NVIDIA)
echo "[20/26] Installing Vulkan drivers..."
# Enable multilib repository for 32-bit support (needed for lib32 packages)
echo "  Enabling multilib repository for 32-bit Vulkan support..."
# Uncomment the [multilib] section in pacman.conf
sudo sed -i '/^\[multilib\]/,/Include/{s/^#//}' /etc/pacman.conf
sudo pacman -Sy --noconfirm
# Install Vulkan drivers with 32-bit support
sudo pacman -S --noconfirm vulkan-tools mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader 2>/dev/null || \
sudo pacman -S --noconfirm vulkan-tools mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader

# Step 21: Install Volta.sh (Node.js version manager)
echo "[21/26] Installing Volta.sh..."
curl https://get.volta.sh | bash
source "$HOME/.bashrc"
volta install node@lts

# Step 22: Install PyEnv (Python version manager)
echo "[22/26] Installing PyEnv and Python 3.12.12..."
# PyEnv dependencies for Arch
sudo pacman -S --noconfirm zlib bzip2 xz openssl readline tk gcc
# Install pyenv
curl https://pyenv.run | bash
# Add pyenv to shell
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
echo 'eval "$(pyenv init -)"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
# Install Python 3.12.12
pyenv install 3.12.12
pyenv global 3.12.12

# Step 23: Initialize Git LFS
echo "[23/26] Initializing Git LFS..."
git lfs install

# Step 24: Create repos directory structure
echo "[24/26] Creating code/repos directory..."
mkdir -p "$HOME/code/repos"

# Step 25: Clone AI inference repositories
echo "[25/26] Cloning llama.cpp and whisper.cpp..."
cd "$HOME/code/repos"
git clone https://github.com/ggerganov/llama.cpp.git
git clone https://github.com/ggerganov/whisper.cpp.git

# Step 26: Initialize Git configuration
echo "[26/26] Setting up Git..."
git config --global init.defaultBranch main
echo "  Git initialized with 'main' as default branch."

echo ""
echo "=== Bootstrap complete! ==="
echo ""
echo "Installed packages:"
echo "  - base-devel (compilation tools)"
echo "  - git + git-lfs (version control)"
echo "  - vim (text editor)"
echo "  - curl + wget (network utilities)"
echo "  - Vulkan SDK 1.4.341.1"
echo "  - Volta.sh + Node LTS"
echo "  - PyEnv + Python 3.12.12"
echo ""
echo "Cloned repositories:"
echo "  - ~/code/repos/llama.cpp"
echo "  - ~/code/repos/whisper.cpp"
echo ""
echo "Next steps:"
echo "  1. Configure git: git config --global user.name 'yourname'"
echo "  2. Configure git: git config --global user.email 'your@email.com'"
echo "  3. Build llama.cpp and whisper.cpp as needed"
