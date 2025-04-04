let
  pins = import ./npins;

  nilla = import pins.nilla;
in
  nilla.create ({config}: {
    includes = [
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
          overlays = [(import ./packages/overlay.nix)];
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
        args.inputs = config.inputs;
        modules = [
          ./nilla/modules/nixos
          "${config.inputs.impermanence.result}/nixos.nix"
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
        args.inputs = config.inputs;
        modules = [
          ./nilla/modules/home
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
