#!/bin/bash
# Arch Linux Desktop Environment Bootstrap Script
# This script optionally installs KDE Plasma desktop environment
# Supports Nvidia, AMD, and Intel GPUs

set -e

echo "=== Arch Linux Desktop Environment Setup ==="
echo ""
echo "This will install KDE Plasma desktop environment."
echo "Recommended for systems with at least 8GB RAM."
echo ""

# Ask for confirmation
read -p "Continue with KDE Plasma installation? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""
echo "[1/4] Updating system packages..."
sudo pacman -Syu --noconfirm

echo ""
echo "[2/4] Installing KDE Plasma (standard group)..."
# Standard KDE Plasma group - includes core desktop utilities
sudo pacman -S --noconfirm plasma-meta kde-applications-meta

echo ""
echo "[3/4] Installing Firefox..."
sudo pacman -S --noconfirm firefox

echo ""
echo "[4/4] Installing GPU-specific drivers..."

# Detect GPU type and install appropriate drivers
lspci_output=$(lspci | grep -i "vga\|3d\|display")

if echo "$lspci_output" | grep -qi "nvidia"; then
    echo "  Detected Nvidia GPU - installing proprietary drivers..."
    # For Nvidia, install both 64-bit and 32-bit (for Vulkan/Proton)
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings lib32-nvidia-utils
elif echo "$lspci_output" | grep -qi "amd"; then
    echo "  Detected AMD GPU - installing open-source drivers..."
    sudo pacman -S --noconfirm mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon
elif echo "$lspci_output" | grep -qi "intel"; then
    echo "  Detected Intel GPU - installing open-source drivers..."
    sudo pacman -S --noconfirm mesa vulkan-intel lib32-mesa lib32-vulkan-intel
else
    echo "  GPU type not clearly detected - installing generic Mesa drivers..."
    sudo pacman -S --noconfirm mesa vulkan-tools lib32-mesa
fi

echo ""
echo "=== Desktop Setup Complete! ==="
echo ""
echo "Installed:"
echo "  - KDE Plasma desktop environment"
echo "  - KDE applications suite"
echo "  - Firefox web browser"
echo "  - GPU drivers (Nvidia/AMD/Intel)"
echo ""
echo "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. At the login screen, select KDE Plasma session"
echo "  3. Configure display settings as needed"
echo ""
echo "To enable display manager (auto-login GUI):"
echo "  sudo systemctl enable sddm"
echo ""
