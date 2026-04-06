#!/bin/bash
# Arch Linux Desktop Environment Bootstrap Script
# This script installs KDE Plasma desktop environment with SDDM login manager
# Supports Nvidia, AMD, and Intel GPUs

set -e

echo "=== Arch Linux Desktop Environment Setup ==="
echo ""
echo "This will install KDE Plasma desktop environment."
echo "Recommended for systems with at least 8GB RAM."
echo ""

echo "[1/7] Updating system packages..."
sudo pacman -Syu --noconfirm

echo "[2/7] Installing NetworkManager for WiFi..."
sudo pacman -S --noconfirm networkmanager network-manager-applet
sudo systemctl enable NetworkManager
echo "  NetworkManager enabled for WiFi/network management."

echo "[3/7] Installing KDE Plasma (standard group)..."
# Standard KDE Plasma group - includes core desktop utilities
sudo pacman -S --noconfirm plasma-meta kde-applications-meta bluedevil sddm
echo "  bluedevil installed for Bluetooth UI pairing."
echo "  sddm installed for display manager."

echo "[4/7] Installing Firefox..."
sudo pacman -S --noconfirm firefox

echo "[5/7] Installing Flatpak..."
sudo pacman -S --noconfirm flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "  Flatpak installed with Flathub repository."

echo "[6/7] Installing GPU-specific drivers..."

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

echo "[7/7] Enabling SDDM display manager..."
sudo systemctl enable sddm

echo ""
echo "=== Desktop Setup Complete! ==="
echo ""
echo "Installed:"
echo "  - NetworkManager for WiFi/network management"
echo "  - KDE Plasma desktop environment"
echo "  - KDE applications suite"
echo "  - bluedevil for Bluetooth UI pairing"
echo "  - Firefox web browser"
echo "  - Flatpak with Flathub repository"
echo "  - GPU drivers (Nvidia/AMD/Intel)"
echo "  - SDDM display manager (enabled)"
echo ""
echo "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. At the login screen, select KDE Plasma session"
echo "  3. Configure display settings as needed"
echo ""
