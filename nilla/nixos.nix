{
  lib,
  config,
}: let
  inherit (config) inputs;
in {
  options.systems = {
    nixos = lib.options.create {
      description = "NixOS systems to create.";
      default.value = {};
      type = lib.types.attrs.of (lib.types.submodule ({config}: {
        options = {
          args = lib.options.create {
            description = "Additional arguments to pass to system modules.";
            type = lib.types.attrs.any;
            default.value = {};
          };

          system = lib.options.create {
            description = ''
              The hostPlatform of the host. The NixOS option `nixpkgs.hostPlatform` in a NixOS module takes precedence over this.
            '';
            type = lib.types.string;
            default.value = "x86_64-linux";
          };

          nixpkgs = lib.options.create {
            description = "The Nixpkgs input to use.";
            type = lib.types.raw;
            default.value =
              if inputs ? nixpkgs
              then inputs.nixpkgs
              else null;
          };

          modules = lib.options.create {
            description = "A list of modules to use for the system.";
            type = lib.types.list.of lib.types.raw;
            default.value = [];
          };

          result = lib.options.create {
            description = "The created NixOS system.";
            type = lib.types.raw;
            writable = false;
            default.value = import "${config.nixpkgs.src}/nixos/lib/eval-config.nix" {
              lib = import "${config.nixpkgs.src}/lib";
              specialArgs = config.args;
              modules =
                config.modules
                ++ [
                  (
                    {lib, ...}: {
                      # Set settings from nixpkgs input as defaults.
                      nixpkgs = {
                        overlays = config.nixpkgs.settings.overlays or [];

                        # Set every leaf in inputs.nixpkgs.settings.configuration
                        # as default with `mkDefault` so it can be overwritten
                        # more easily in a module.
                        config = lib.mapAttrsRecursive (_: lib.mkDefault) (config.nixpkgs.settings.configuration or {});

                        # Higher priority than `mkOptionDefault` but lower than `mkDefault`.
                        hostPlatform = lib.mkOverride 1400 config.system;
                      };
                    }
                  )
                ];
              modulesLocation = null;
            };
          };
        };
      }));
    };
  };

  config = {
    assertions =
      lib.attrs.mapToList
      (name: value: {
        assertion = !(builtins.isNull value.nixpkgs);
        message = "A Nixpkgs instance is required for the NixOS system \"${name}\", but none was provided and \"inputs.nixpkgs\" does not exist.";
      })
      config.systems.nixos;
  };
}
