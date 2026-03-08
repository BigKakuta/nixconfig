#!/usr/bin/env bash

set -euo pipefail

DISK="/dev/nvme0n1"

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
parted "$DISK" --script -- mklabel gpt
parted "$DISK" --script -- mkpart ESP fat32 1MiB 512MiB
parted "$DISK" --script -- set 1 esp on
parted "$DISK" --script -- set 1 boot on
parted "$DISK" --script -- mkpart Nix 512MiB 100%

echo
echo "Partitioning complete."
echo "Updated disk layout:"
lsblk "$DISK"
parted "$DISK" --script print
