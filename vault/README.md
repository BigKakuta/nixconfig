---
status: resolved
date: 2026-03-13
---

# NixOS install: `sgdisk` overlap

Related: [[Obsidian]] [[NixOS]] [[install.sh]] [[sgdisk]] [[GPT partitioning]]

## Problem

`install.sh` failed during partition creation:

```text
Could not create partition 2 from 4096 to 1052672
Error encountered; not saving changes.
```

## Root cause

The intended layout was correct, but the `sgdisk` boundaries in `install.sh` overlapped.
`sgdisk` uses inclusive end sectors, so these commands reused the same boundary sector:

```sh
sgdisk -n 1:1MiB:2MiB ...
sgdisk -n 2:2MiB:514MiB ...
sgdisk -n 3:514MiB:0 ...
```

## Fix

Use relative sizes and let `sgdisk` pick the next aligned free start:

```sh
sgdisk --zap-all "$DISK"
sgdisk -n 1:1MiB:+1MiB -t 1:ef02 -c 1:"disk-main-boot" "$DISK"
sgdisk -n 2:0:+512MiB -t 2:ef00 -c 2:"disk-main-ESP" "$DISK"
sgdisk -n 3:0:0 -t 3:8300 -c 3:"disk-main-nix" "$DISK"
```

## Result

No overlapping GPT boundaries. The layout now matches the intended BIOS boot + ESP + `nix` partitions.
