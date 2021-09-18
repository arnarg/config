{

  description = "arnarg's NixOS configuration";

  ############
  ## INPUTS ##
  ############
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.1.0";

    home = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  #############
  ## OUTPUTS ##
  #############
  outputs = inputs@{ self, utils, home, nixpkgs, ... }:
    let
      mkApp = utils.lib.mkApp;
    in utils.lib.systemFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      ############
      # Channels #
      ############
      sharedOverlays = [ self.overlay ];
      channels.nixpkgs = {
        input = nixpkgs;
        config = { allowUnfree = true; };
      };

      #########
      # Hosts #
      #########
      hostDefaults.modules = [
        utils.nixosModules.saneFlakeDefaults
        ./modules
        {
          nix = {
            trustedUsers = [ "root" "arnar" ];
            binaryCaches = [ "https://arnarg.cachix.org" ];
            binaryCachePublicKeys = [ "arnarg.cachix.org-1:QwvsbygCMQHexg8JVwILYFrZwnWwMfH08O8SH6HsVaw=" ];

            nixPath = [
              "nixpkgs=${self}/compat"
              "nixos-config=${self}/compat/nixos"
            ];
          };
        }
      ];

      hosts = {
        flex.modules = [
          ./machines/flex/configuration.nix
          self.nixosModules.desktop
          self.nixosModules.development
          self.nixosModules.laptop
          self.nixosModules.tablet
          {
            # Get home manager in path
            environment.systemPackages = [
              nixpkgs.legacyPackages.x86_64-linux.git
              home.packages.x86_64-linux.home-manager
            ];
          }
        ];
        terramaster.modules = [
          ./machines/terramaster/configuration.nix
          self.nixosModules.server
        ];
      };

      nixosModules = utils.lib.modulesFromList [
        ./profiles/desktop
        ./profiles/development
        ./profiles/laptop
        ./profiles/server
        ./profiles/tablet
      ];

      ########
      # HOME #
      ########
      homeConfigurations =
        let
          username = "arnar";
          homeDirectory = "/home/arnar";
          system = "x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          generateHome = home.lib.homeManagerConfiguration;
          nixpkgs = {
            config = {
              allowUnfree = true;
            };
            overlays = [
              self.overlay
            ];
          };
        in
          {
            arnar = generateHome {
              inherit system username homeDirectory extraSpecialArgs;
              configuration = {
                imports = [
                  self.homeModules.development
                  self.homeModules.desktop
                  ./home/desktop/gnome
                ];
                inherit nixpkgs;
              };
            };
          };

      homeModules = utils.lib.modulesFromList [
        ./home/development
        ./home/desktop
      ];

      overlay = import ./packages/overlay.nix;
      legacyPackages = nixpkgs.legacyPackages;
    };

}
