{
  description = "arnarg's NixOS configuration";

  ############
  ## INPUTS ##
  ############
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.4.0";
    hardware.url = "github:nixos/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence/master";

    home = {
      url = "github:nix-community/home-manager/release-23.05";
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
    unstable,
    impermanence,
    ...
  }:
    utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = ["x86_64-linux" "aarch64-linux"];

      ############
      # Channels #
      ############
      sharedOverlays = [
        self.overlay
        (p: _: {
          home-manager = home.packages.${p.system}.home-manager;
          tailscale = unstable.legacyPackages.${p.system}.tailscale;
        })
      ];
      channelsConfig = {allowUnfree = true;};

      #########
      # Hosts #
      #########
      hostDefaults.modules = [
        self.nixosModules.base
        impermanence.nixosModules.impermanence
      ];

      hosts = {
        framework = import ./machines/framework {inherit inputs;};
        thinkpad = import ./machines/thinkpad {inherit inputs;};
        terramaster = import ./machines/terramaster {inherit inputs;};
        terra = import ./machines/terra {inherit inputs;};
        r4s = import ./machines/r4s {inherit inputs;};
        links = import ./machines/workers/links {inherit inputs;};
        rechts = import ./machines/workers/rechts {inherit inputs;};
      };

      nixosModules = utils.lib.exportModules [
        ./profiles/base
        ./profiles/desktop
        ./profiles/development
        ./profiles/immutable
        ./profiles/laptop
        ./profiles/server
        ./profiles/tpm
      ];

      ########
      # HOME #
      ########
      homeConfigurations = let
        system = "x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
          inherit (self) homeModules;
          stable = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
        generateHome = home.lib.homeManagerConfiguration;
        pkgs = import unstable {
          inherit system;
          overlays = [
            self.overlay
          ];
          config.allowUnfree = true;
        };
      in {
        framework = generateHome {
          inherit pkgs extraSpecialArgs;
          modules = [./home/framework.nix];
        };
        thinkpad = generateHome {
          inherit pkgs extraSpecialArgs;
          modules = [./home/thinkpad.nix];
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
