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
DISK_BOOT_PARTITION="/dev/nvme0n1p1"
DISK_ROOT_PARTITION="/dev/nvme0n1p2"

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
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 boot on
parted $DISK -- mkpart Root 512MiB 100%
echo -e "\033[32mDisk partitioned successfully.\033[0m"

echo
echo "Creating filesystems..."
mkfs.fat -F32 -n boot "$DISK_BOOT_PARTITION"
mkfs.ext4 -F -L root "$DISK_ROOT_PARTITION"
sleep 2
echo
echo "Mounting filesystems..."
mount "$DISK_ROOT_PARTITION" /mnt/
mkdir -p /mnt/boot 
mount "$DISK_BOOT_PARTITION" /mnt/boot
echo
echo "Mounts complete:"
findmnt /mnt/
findmnt /mnt/boot
