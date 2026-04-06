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
echo "[2/10] Installing base development packages..."
sudo pacman -S --noconfirm base-devel git git-lfs vim curl wget tk

# Step 3: Install FFmpeg and video codecs
echo "[3/10] Installing FFmpeg and video codecs..."
sudo pacman -S --noconfirm ffmpeg ffmpeg4.4 \
  libaom dav1d librav1e svt-av1 \
  x264 x265 vpx

# Step 4: Install Vulkan SDK
echo "[4/10] Installing Vulkan SDK..."
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

# Step 5: Install Vulkan drivers (AMD/Intel/NVIDIA)
echo "[5/10] Installing Vulkan drivers..."
sudo pacman -S --noconfirm vulkan-tools mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader 2>/dev/null || \
sudo pacman -S --noconfirm vulkan-tools mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader

# Step 6: Install Volta.sh (Node.js version manager)
echo "[6/10] Installing Volta.sh..."
curl https://get.volta.sh | bash
source "$HOME/.bashrc"
volta install node@lts

# Step 7: Install PyEnv (Python version manager)
echo "[7/10] Installing PyEnv and Python 3.12.12..."
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

# Step 8: Initialize Git LFS
echo "[8/10] Initializing Git LFS..."
git lfs install

# Step 9: Create repos directory structure
echo "[9/10] Creating code/repos directory..."
mkdir -p "$HOME/code/repos"

# Step 10: Clone AI inference repositories
echo "[10/10] Cloning llama.cpp and whisper.cpp..."
cd "$HOME/code/repos"
git clone https://github.com/ggerganov/llama.cpp.git
git clone https://github.com/ggerganov/whisper.cpp.git

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
