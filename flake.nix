{

  description = "arnarg's NixOS configuration";

  ############
  ## INPUTS ##
  ############
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix = { url = "github:nixos/nix"; };
    home = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  #############
  ## OUTPUTS ##
  #############
  outputs = inputs: {
    
    nixosConfigurations = {
      flex = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/flex/configuration.nix
          inputs.home.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };

    lib = {
      mkMachine =
        { system
        , pkgs
        , hostname
        , extraModules ? {}
        }:
        {}
    };
  };

}
