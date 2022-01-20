# config

This repository hosts NixOS configuration for my various machines.

## Install

```
nixos-rebuild switch --flake .#<target host>
```

## Layout

```
.
├── home      # Profiles for home-manager configuration
│   └── */
├── machines  # Host specific configuration
│   └── */
├── packages  # My own packages that are not available in nixpkgs
│   └── *.nix
└── profiles  # Profiles for NixOS configuration
    └── */
```
