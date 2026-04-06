#!/bin/bash
# Arch Linux AI Development Bootstrap Script
# This script sets up a minimal Arch Linux environment for AI development

set -e

echo "=== Arch Linux AI Development Bootstrap ==="
echo ""

# Step 1: System updates
echo "[1/3] Updating system packages..."
sudo pacman -Syu --noconfirm

# Step 2: Install base development tools
echo "[2/3] Installing base development packages..."
sudo pacman -S --noconfirm base-devel git git-lfs vim curl wget

# Step 3: Initialize Git LFS
echo "[3/3] Initializing Git LFS..."
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
