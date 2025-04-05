{
  lib,
  config,
}: let
  inherit (config) inputs;
in {
  options.systems = {
    home = lib.options.create {
      description = "home-manager systems to create.";
      default.value = {};
      type = lib.types.attrs.of (lib.types.submodule ({config}: {
        options = {
          args = lib.options.create {
            description = "Additional arguments to pass to home-manager modules.";
            type = lib.types.attrs.any;
            default.value = {};
          };

          system = lib.options.create {
            description = "The system of pkgs to use.";
            type = lib.types.string;
            default.value = "x86_64-linux";
          };

          home-manager = lib.options.create {
            description = "The home-manager input to use.";
            type = lib.types.raw;
            default.value =
              if inputs ? home
              then inputs.home
              else null;
          };

          pkgs = lib.options.create {
            description = "The Nixpkgs instance to use.";
            type = lib.types.raw;
            default.value =
              if
                inputs
                ? nixpkgs
                && inputs.nixpkgs.result ? ${config.system}
              then inputs.nixpkgs.result.${config.system}
              else null;
          };

          modules = lib.options.create {
            description = "A list of modules to use for home-manager.";
            type = lib.types.list.of lib.types.raw;
            default.value = [];
          };

          result = lib.options.create {
            description = "The created home-manager system.";
            type = lib.types.raw;
            writable = false;
            default.value = let
              src = config.home-manager.src;
              contents = builtins.readDir src;
              directories = lib.attrs.filter (name: value: value == "directory") contents;

              builder =
                if directories ? "lib" && (builtins.readDir "${src}/lib") ? "default.nix"
                then (import "${src}/lib").homeManagerConfiguration
                else
                  {
                    pkgs,
                    lib,
                    extraSpecialArgs,
                    modules,
                  }:
                    import "${src}/modules" {
                      inherit pkgs lib extraSpecialArgs;
                      check = true;
                      configuration = {lib, ...}: {
                        imports = modules;
                        nixpkgs = {
                          config = lib.mkDefault pkgs.config;
                          inherit (pkgs) overlays;
                        };
                      };
                    };
            in
              builder {
                pkgs = config.pkgs;
                lib = config.pkgs.lib;
                extraSpecialArgs = config.args;
                modules = config.modules;
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
        assertion = !(builtins.isNull value.pkgs);
        message = "A Nixpkgs instance is required for the home-manager configuration \"${name}\", but none was provided and \"inputs.nixpkgs\" does not exist.";
      })
      config.systems.home;
  };
}
