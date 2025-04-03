let
  pins = import ./npins;

  nilla = import pins.nilla;
in
  nilla.create ({config}: {
    includes = [
      ./nilla
      "${pins.nilla-nixos}/modules/nixos.nix"
    ];

    config = {
      generators.inputs.pins = pins;
      generators.nixos = {
        folder = ./nilla/hosts;
        modules = [
          ./modules
          config.inputs.impermanence.result.nixosModules.default
          {
            # Set nixpkgs in registry.json
            nix.registry.nixpkgs = {
              from = {
                id = "nixpkgs";
                type = "indirect";
              };
              to = {
                type = "path";
                path = config.inputs.nixpkgs.src;
              };
            };

            # Set NIX_PATH to /etc/nix/inputs and create those symlinks
            nix.nixPath = ["/etc/nix/inputs"];
            environment.etc = builtins.listToAttrs (config.lib.attrs.mapToList (n: val: {
                name = "nix/inputs/${n}";
                value.source = val.src;
              })
              config.inputs);
          }
        ];
      };

      inputs = {
        nixpkgs.settings.configuration.allowUnfree = true;

        hardware.loader = "flake";
        impermanence.loader = "flake";
      };

      systems.nixos = {
        framework.modules = [
          config.inputs.hardware.result.nixosModules.framework-12th-gen-intel
          {
            environment.systemPackages = [config.inputs.lila.result.packages.default.result.x86_64-linux];
          }
        ];
      };
    };
  })
