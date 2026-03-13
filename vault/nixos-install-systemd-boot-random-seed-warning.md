---
status: resolved
date: 2026-03-13
---

# NixOS install: systemd-boot random seed warning

Related: [[Obsidian]] [[NixOS]] [[disko]] [[systemd-boot]] [[EFI]] [[vfat]] [[bootctl]]

## Problem

`nixos-install` completed, but `systemd-boot` warned that `/boot` and the random seed file were world accessible.

## Root cause

The EFI System Partition is mounted at `/boot` as `vfat`. Without restrictive mount masks, FAT appears world accessible, so `bootctl` warns about `/boot/loader/random-seed`.

## Fix

Add a restrictive mount mask to the ESP in `modules/disko.nix`:

```nix
content = {
  type = "filesystem";
  format = "vfat";
  mountpoint = "/boot";
  mountOptions = [ "umask=0077" ];
};
```

## Result

Future installs should mount `/boot` with private permissions and avoid the random seed warning.
