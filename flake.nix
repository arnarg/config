{
  description = "arnarg's NixOS configuration";

  ############
  ## INPUTS ##
  ############
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
    hardware.url = "github:nixos/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence/master";

    home = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  #############
  ## OUTPUTS ##
  #############
  outputs = inputs @ {
    self,
    utils,
    home,
    nixpkgs,
    unstable,
    hardware,
    impermanence,
    ...
  }:
    utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = ["x86_64-linux" "aarch64-linux"];

      ############
      # Channels #
      ############
      sharedOverlays = [self.overlay];
      channelsConfig = {allowUnfree = true;};

      #########
      # Hosts #
      #########
      hostDefaults.modules = [
        self.nixosModules.base
        impermanence.nixosModules.impermanence
        {
          nix.generateNixPathFromInputs = true;
          nix.generateRegistryFromInputs = true;
          nix.trustedUsers = ["root" "arnar"];
        }
      ];

      hosts = {
        flex.modules = [
          ./machines/flex/configuration.nix
          self.nixosModules.immutable
          self.nixosModules.desktop
          self.nixosModules.development
          self.nixosModules.laptop
          {
            # Get home manager in path
            environment.systemPackages = [
              nixpkgs.legacyPackages.x86_64-linux.git
              home.packages.x86_64-linux.home-manager
            ];
          }
        ];
        framework.modules = [
          ./machines/framework/configuration.nix
          self.nixosModules.immutable
          self.nixosModules.desktop
          self.nixosModules.development
          self.nixosModules.laptop
          hardware.nixosModules.framework-12th-gen-intel
          {
            # Get home manager in path
            environment.systemPackages = [
              nixpkgs.legacyPackages.x86_64-linux.git
              home.packages.x86_64-linux.home-manager
            ];
          }
        ];
        terramaster = let
          system = "x86_64-linux";
          pkgs = import unstable {
            inherit system;
            overlays = [
              self.overlay
            ];
            config.allowUnfree = true;
          };
        in {
          modules = [
            ./machines/terramaster/configuration.nix
            self.nixosModules.immutable
            self.nixosModules.server
            {
              environment.systemPackages = [
                pkgs.redpanda
              ];
            }
          ];
        };
        tiny1 = {
          system = "aarch64-linux";
          modules = [
            {
              networking.hostName = "tiny1";
            }
            ./machines/tiny/configuration.nix
            self.nixosModules.immutable
            self.nixosModules.server
          ];
        };
      };

      nixosModules = utils.lib.exportModules [
        ./profiles/base
        ./profiles/desktop
        ./profiles/development
        ./profiles/immutable
        ./profiles/laptop
        ./profiles/server
      ];

      ########
      # HOME #
      ########
      homeConfigurations = let
        username = "arnar";
        homeDirectory = "/home/arnar";
        system = "x86_64-linux";
        extraSpecialArgs = {inherit inputs;};
        generateHome = home.lib.homeManagerConfiguration;
        pkgs = import unstable {
          inherit system;
          overlays = [
            self.overlay
          ];
          config.allowUnfree = true;
        };
      in {
        arnar = generateHome {
          inherit system username homeDirectory extraSpecialArgs pkgs;
          configuration = {
            imports = [
              self.homeModules.development
              self.homeModules.desktop
              ./home/desktop/gnome
              ./home/development/redpanda
            ];
          };
        };
      };

      homeModules = utils.lib.exportModules [
        ./home/development
        ./home/desktop
      ];

      overlay = import ./packages/overlay.nix;

      outputsBuilder = let
        overlays = utils.lib.exportOverlays {inherit (self) inputs pkgs;};
      in
        channels: {
          packages = utils.lib.exportPackages overlays channels;
        };
    };
}
