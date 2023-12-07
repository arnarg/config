{
  description = "arnarg's NixOS configuration";

  ############
  ## INPUTS ##
  ############
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.4.0";
    hardware.url = "github:nixos/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence/master";
    pam-k8s-sa.url = "github:arnarg/pam-k8s-sa/main";

    home = {
      url = "github:nix-community/home-manager/release-23.11";
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
    pam-k8s-sa,
    ...
  }: let
    directory = ./hosts;
  in {
    lib = import ./lib;

    ###########
    ## NixOS ##
    ###########
    nixosConfigurations = self.lib.genNixOSHosts {
      inherit inputs nixpkgs directory;

      baseModules = [
        utils.nixosModules.autoGenFromInputs
        impermanence.nixosModules.impermanence
        self.nixosModules.default
      ];

      overlays = [
        (import ./packages/overlay.nix)
        pam-k8s-sa.overlays.default
      ];

      config.allowUnfree = true;
    };

    nixosModules.default = import ./modules;

    ##################
    ## Home Manager ##
    ##################
    homeConfigurations = self.lib.genHomeHosts {
      inherit inputs nixpkgs home directory;

      user = "arnar";

      baseModules = [
        self.homeModules.default
      ];

      overlays = [
        (import ./packages/overlay.nix)
      ];

      config.allowUnfree = true;
    };

    homeModules = {
      default = import ./modules/home;
      desktop = import ./home/desktop;
      development = import ./home/development;
    };
  };
}
