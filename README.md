# config

This repository hosts NixOS configuration for my various machines.

## Install

Initial rebuild requires an explicit nixos-config path.

```
nixos-rebuild switch -I nixos-config=$HOME/Code/config/machines/<target machine>/configuration.nix
```

## Layout

```
.
├── machines  # Each subdirectory contains configuration for a single machine
│   └── */
├── modules   # My own NixOS modules
│   └── */
├── overlays  # Any nixpkgs overlays
│   └── *.nix
└── packages  # My own packages that are not available in nixpkgs
    └── */
```
