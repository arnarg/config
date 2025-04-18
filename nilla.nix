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
        nixos-unstable.settings = config.inputs.nixpkgs.settings;

        hardware.loader = "raw";
        impermanence.loader = "raw";
      };

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

      #######################
      ## Special overrides ##
      #######################
      # Move framework to nixos-unstable
      systems.nixos.framework.nixpkgs = config.inputs.nixos-unstable;
      systems.home."arnar@framework".pkgs = config.inputs.nixos-unstable.result.x86_64-linux;
    };
  })
