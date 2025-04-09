let
  pins = import ./npins;

  nilla = import pins.nilla;
in
  nilla.create ({config}: {
    includes = [
      "${pins.nilla-utils}/modules"
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

      generators.packages.folder = ./packages;

      ###########
      ## NixOS ##
      ###########
      # Generate nixos hosts from folders in ./hosts
      generators.nixos = {
        folder = ./hosts;
        modules = [
          config.modules.nixos.default
        ];
      };

      # Export NixOS module
      modules.nixos.default = ./modules/nixos;

      ##################
      ## Home Manager ##
      ##################
      # Generate home-manager configurations from folders in
      # ./hosts
      generators.home = {
        username = "arnar";
        folder = ./hosts;
        modules = [
          config.modules.home.default
        ];
      };

      # Export home-manager module
      modules.home.default = ./modules/home;

      ##############
      ## Overlays ##
      ##############
      # Generate `default` overlay using `./packages`
      # folder structure
      generators.overlays.default.folder = ./packages;
    };
  })
