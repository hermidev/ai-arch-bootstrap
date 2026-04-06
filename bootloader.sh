#!/bin/bash
# Arch Linux GRUB EFI Bootloader Installation Script
# This script installs GRUB bootloader for UEFI systems

set -e

echo "=== Arch Linux GRUB EFI Bootloader Setup ==="
echo ""

# Step 1: Check for UEFI
echo "[1/6] Checking for UEFI system..."
if [ ! -d /sys/firmware/efi ]; then
    echo "  ERROR: Not booted in UEFI mode!"
    echo "  This script requires UEFI boot mode."
    exit 1
fi
echo "  UEFI system detected."

# Step 2: Install GRUB and efibootmgr
echo "[2/6] Installing GRUB and efibootmgr..."
sudo pacman -S --noconfirm grub efibootmgr os-prober
echo "  GRUB and EFI tools installed."

# Step 3: Create EFI mount point
echo "[3/6] Preparing EFI system partition..."
EFI_MOUNT_POINT="/boot"
if [ ! -d "$EFI_MOUNT_POINT" ]; then
    mkdir -p "$EFI_MOUNT_POINT"
    echo "  Created $EFI_MOUNT_POINT directory."
fi

# Step 4: Mount EFI partition (if not already mounted)
echo "[4/6] Checking EFI partition mount..."
if ! mountpoint -q "$EFI_MOUNT_POINT"; then
    # Try to find and mount EFI partition
    EFI_PARTITION=$(lsblk -o NAME,FSTYPE,MOUNTPOINT | grep -E "vfat.*boot" | awk '{print $1}' | head -1)
    if [ -n "$EFI_PARTITION" ]; then
        sudo mount /dev/$EFI_PARTITION "$EFI_MOUNT_POINT"
        echo "  Mounted /dev/$EFI_PARTITION to $EFI_MOUNT_POINT"
    else
        echo "  WARNING: EFI partition not found. Please mount manually."
        echo "  Example: sudo mount /dev/nvme0n1p1 /boot"
        exit 1
    fi
else
    echo "  EFI partition already mounted at $EFI_MOUNT_POINT"
fi

# Step 5: Install GRUB to EFI
echo "[5/6] Installing GRUB to EFI system partition..."
sudo grub-install --target=x86_64-efi --efi-directory=$EFI_MOUNT_POINT --bootloader-id=ArchLinux --recheck
echo "  GRUB installed to EFI partition."

# Step 6: Generate GRUB configuration
echo "[6/6] Generating GRUB configuration..."
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "  GRUB configuration generated."

echo ""
echo "=== GRUB EFI Bootloader Installation Complete! ==="
echo ""
echo "Installed components:"
echo "  - GRUB bootloader (UEFI)"
echo "  - efibootmgr"
echo "  - os-prober (for dual-boot detection)"
echo ""
echo "Next steps:"
echo "  1. Install your operating system(s)"
echo "  2. Reboot: sudo reboot"
echo "  3. Select 'ArchLinux' from GRUB menu"
echo ""
echo "To add other OS entries (Windows, etc.):"
echo "  sudo pacman -S os-prober"
echo "  sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo ""
