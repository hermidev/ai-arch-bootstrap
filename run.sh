#!/bin/bash
# Arch Linux AI Development Bootstrap Script
# This script sets up a minimal Arch Linux environment for AI development

set -e

echo "=== Arch Linux AI Development Bootstrap ==="
echo ""

# Step 1: System updates
echo "[1/7] Updating system packages..."
sudo pacman -Syu --noconfirm

# Step 2: Install base development tools
echo "[2/7] Installing base development packages..."
sudo pacman -S --noconfirm base-devel git git-lfs vim curl wget tk

# Step 3: Install Vulkan SDK
echo "[3/7] Installing Vulkan SDK..."
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

# Step 4: Install Vulkan drivers (AMD/Intel/NVIDIA)
echo "[4/7] Installing Vulkan drivers..."
sudo pacman -S --noconfirm vulkan-tools mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader 2>/dev/null || \
sudo pacman -S --noconfirm vulkan-tools mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader

# Step 5: Install Volta.sh (Node.js version manager)
echo "[5/7] Installing Volta.sh..."
curl https://get.volta.sh | bash
source "$HOME/.bashrc"
volta install node@lts

# Step 6: Install PyEnv (Python version manager)
echo "[6/7] Installing PyEnv and Python 3.12.12..."
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

# Step 7: Initialize Git LFS
echo "[7/7] Initializing Git LFS..."
git lfs install

echo ""
echo "=== Bootstrap complete! ==="
echo ""
echo "Installed packages:"
echo "  - base-devel (compilation tools)"
echo "  - git + git-lfs (version control)"
echo "  - vim (text editor)"
echo "  - curl + wget (network utilities)"
echo ""
echo "Next steps:"
echo "  1. Configure git: git config --global user.name 'yourname'"
echo "  2. Configure git: git config --global user.email 'your@email.com'"
echo "  3. Clone your repositories and start developing!"
