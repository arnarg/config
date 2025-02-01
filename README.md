# config

This repository hosts NixOS configuration for my various machines.

## Install

```
nixos-rebuild switch --flake .#<target host>
```

## My custom lib

I felt that I was writing a bit of boilerplate every time I was adding a new host in `nixosConfigurations` along with `homeConfigurations` in my `flake.nix`. Therefore I wrote some nix code to walk the `./hosts` directory, look for a `default.nix` file in there that sets some metadata to setup the nixos configuration and optionally home configuration.

Example:

```nix
# ./hosts/framework/default.nix
{
 # All flake inputs will be passed
 # as a parameter.
 hardware,
 ...
}: {
  # This is a x86_64 system
  system = "x86_64-linux";

  # Modules to be imported
  modules = [
    ./configuration.nix
    hardware.nixosModules.framework-12th-gen-intel
  ];

  # Home modules to be imported
  home.modules = [
    ./home.nix
  ];
}
```

## Layout

```
.
├── hosts/*/default.nix  # My hosts for NixOS and home-manager
├── lib/default.nix      # My custom lib
├── modules/             # Modules for NixOS and home-manager
└── packages             # My own packages that are not available in nixpkgs
```
