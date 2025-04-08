let
  pins = import ./npins;

  nilla = import pins.nilla;
in
  nilla.create ({config}: {
    includes = [
      "${pins.nilla-utils}/modules"
      ./nilla
    ];

    config = {
      ############
      ## Inputs ##
      ############
      # Generate inputs from npins
      generators.inputs.pins = pins;

      # Override specific input settings and loaders
      inputs = {
        nixpkgs.settings = {
          configuration.allowUnfree = true;
          overlays = [config.overlays.default];
        };

        hardware.loader = "raw";
        impermanence.loader = "raw";
      };

      ###########
      ## NixOS ##
      ###########
      # Generate nixos hosts from folders in ./nilla/hosts
      generators.nixos = {
        folder = ./nilla/hosts;
        modules = [
          config.modules.nixos.default
        ];
      };

      ##################
      ## Home Manager ##
      ##################
      # Generate home-manager configurations from folders in
      # ./nilla/hosts
      generators.home = {
        username = "arnar";
        folder = ./nilla/hosts;
        modules = [
          config.modules.home.default
        ];
      };

      ############
      ## Shells ##
      ############
      shells.default = {
        systems = ["x86_64-linux" "aarch64-linux"];

        builder = "nixpkgs";
        settings.pkgs = config.inputs.nixpkgs.result;

        shell = {
          mkShellNoCC,
          npins,
          ...
        }:
          mkShellNoCC {
            packages = [npins];
          };
      };
    };
  })
