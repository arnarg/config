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
                  {
                    nixpkgs.config = config.nixpkgs.settings.configuration or {};
                    nixpkgs.overlays = config.nixpkgs.settings.overlays or [];
                  }
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
