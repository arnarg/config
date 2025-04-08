# config

This repository hosts NixOS configuration for my various machines. It uses [nilla](https://github.com/nilla-nix/nilla) with [nilla-utils](https://github.com/arnarg/nilla-utils).

## Install

```
nixos-install -f nilla.nix -A systems.nixos.<name>.result
```

## Layout

```
.
├── hosts/*              # My hosts for NixOS and home-manager
├── modules/             # Modules for NixOS and home-manager
└── packages             # My own packages that are not available in nixpkgs
```
