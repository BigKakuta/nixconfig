#!/usr/bin/env bash

# Copyright (c) 2023 Eric Cheng
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

set -euo pipefail

DISK="/dev/nvme0n1"
DISK_BIOS_PARTITION="/dev/nvme0n1p1"
DISK_BOOT_PARTITION="/dev/nvme0n1p2"
DISK_ROOT_PARTITION="/dev/nvme0n1p4"

if [ "$(uname)" != "Linux" ]; then
  echo "This script only supports Linux."
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root (or via sudo)."
  exit 1
fi

if [ ! -b "$DISK" ]; then
  echo "Disk not found: $DISK"
  exit 1
fi

echo "Linux detected"
echo "Automation mode: partitioning $DISK without interactive prompts."
echo "This is destructive and will erase existing partition data on $DISK."

echo
echo "Current disk layout:"
lsblk "$DISK"

echo
echo "Partitioning disk..."
sgdisk --zap-all "$DISK"
sgdisk -n 1:1MiB:+1MiB -t 1:ef02 -c 1:"disk-main-boot" "$DISK"
sgdisk -n 2:0:+512MiB -t 2:ef00 -c 2:"disk-main-ESP" "$DISK"
sgdisk -n 3:0:0 -t 3:8300 -c 3:"disk-main-root" "$DISK"

echo
echo "Partitioning complete."
echo "Updated disk layout:"
lsblk "$DISK"
sgdisk -p "$DISK"

echo
echo "Creating filesystems..."
mkfs.fat -F32 -n boot "$DISK_BOOT_PARTITION"
mkfs.ext4 -F -L nix "$DISK_ROOT_PARTITION"

echo
echo "Mounting filesystems..."
mkdir -p /mnt/boot /mnt/nix
mount "$DISK_BOOT_PARTITION" /mnt/boot
mount "$DISK_ROOT_PARTITION" /mnt/

echo
echo "Mounts complete:"
findmnt /mnt/boot
findmnt /mnt/
