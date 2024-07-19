{
  description = "arnarg's NixOS configuration";

  ############
  ## INPUTS ##
  ############
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.4.0";
    hardware.url = "github:nixos/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence/master";

    home = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #############
  ## OUTPUTS ##
  #############
  outputs = inputs @ {
    self,
    nixpkgs,
    impermanence,
    utils,
    home,
    ...
  }: {
    lib = import ./lib;

    ###########
    ## NixOS ##
    ###########
    nixosConfigurations = self.lib.genNixOSHosts {
      inherit inputs;

      baseModules = [
        utils.nixosModules.autoGenFromInputs
        impermanence.nixosModules.impermanence
        self.nixosModules.default
      ];

      overlays = [
        (import ./packages/overlay.nix)
      ];
    };

    nixosModules.default = import ./modules;

    ##################
    ## Home Manager ##
    ##################
    homeConfigurations = self.lib.genHomeHosts {
      inherit inputs;

      user = "arnar";

      baseModules = [
        self.homeModules.default
      ];

      overlays = [
        (import ./packages/overlay.nix)
      ];
    };

    homeModules.default = import ./modules/home;
  };
}
