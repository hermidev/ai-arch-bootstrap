#!/bin/bash
# Arch Linux AI Development Bootstrap Script
# This script sets up a minimal Arch Linux environment for AI development

set -e

echo "=== Arch Linux AI Development Bootstrap ==="
echo ""

# Step 1: System updates
echo "[1/5] Updating system packages..."
sudo pacman -Syu --noconfirm

# Step 2: Install base development tools
echo "[2/5] Installing base development packages..."
sudo pacman -S --noconfirm base-devel git git-lfs vim curl wget tk

# Step 3: Install Volta.sh (Node.js version manager)
echo "[3/5] Installing Volta.sh..."
curl https://get.volta.sh | bash
source "$HOME/.bashrc"
volta install node@lts

# Step 4: Install PyEnv (Python version manager)
echo "[4/5] Installing PyEnv and Python 3.12.12..."
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

# Step 5: Initialize Git LFS
echo "[5/5] Initializing Git LFS..."
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
