{

  description = "arnarg's NixOS configuration";

  ############
  ## INPUTS ##
  ############
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";

    nix = { url = "github:nixos/nix"; };
    home = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-wayland  = { url = "github:colemickens/nixpkgs-wayland"; };
  };

  #############
  ## OUTPUTS ##
  #############
  outputs = inputs:
    let
      config = {allowUnfree = true;};
      pkgsFor = pkgs: system:
        import pkgs {
          inherit system config;
          overlays = [ (import ./overlay.nix) ];
        };

      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);

      allSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: genAttrs allSystems
        (system: f {
          inherit system;
          pkgs = pkgsFor inputs.nixpkgs system;
        });
    in
    {
      nixosConfigurations = {
        flex = 
          inputs.self.lib.mkMachine {
            system = "x86_64-linux";
            hostname = "flex";
            profiles = [
              "desktop"
              "laptop"
              "tablet"
              "development"
            ];
          };

        terramaster =
          inputs.self.lib.mkMachine {
            system = "x86_64-linux";
            channel = inputs.stable;
            hostname = "terramaster";
            profiles = [ "server" ];
          };

        worker1 =
          inputs.self.lib.mkMachine {
            system = "aarch64-linux";
            channel = inputs.stable;
            hostname = "worker1";
            profiles = [ "server" ];
            baseConfig = ./machines/worker/configuration.nix;
          };
      };

      lib = {
        mkMachine =
          { system
          , channel ? inputs.nixpkgs
          , hostname
          , profiles ? []
          , baseConfig ? ./machines + "/${hostname}/configuration.nix"
          , extraModules ? []
          , flake ? inputs.self
          }:
          let
            inherit (pkgs) lib;
            pkgs = pkgsFor channel system;

            needsHM = x:
              x == "desktop" || x == "laptop" ||
              x == "tablet"  || x == "development";
            profilesToModules = with lib; p:
              forEach p (x: ./profiles + "/${x}/") ++
              optionals (any needsHM p) [
                inputs.home.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                }
              ];

            nix = { ... }: {
              nix = {
                package = lib.mkForce inputs.nix.defaultPackage.${system};

                trustedUsers = [ "root" "arnar" ];
                binaryCaches = [ "https://arnarg.cachix.org" ];
                binaryCachePublicKeys = [ "arnarg.cachix.org-1:QwvsbygCMQHexg8JVwILYFrZwnWwMfH08O8SH6HsVaw=" ];

                # print-build-logs = true
                # log-format = bar-with-logs
                extraOptions = ''
                  flake-registry = /etc/nix/registry.json
                  experimental-features = nix-command flakes
                '';

                nixPath = [
                  "nixpkgs=${flake}/compat"
                  "nixos-config=${flake}/compat/nixos"
                ];

                registry = {
                  self.flake = flake;

                  nixpkgs = {
                    from = { id = "nixpkgs"; type = "indirect"; };
                    flake = flake;
                  };
                };
              };
            };

            specialArgs = {
              inherit inputs system;
              mypkgs = import ./packages {inherit pkgs;};
            };

            misc = { ... }: {
              _module.args = specialArgs;
              nixpkgs.pkgs = pkgs;
            };

            modules = extraModules ++ (profilesToModules profiles) ++ [
              { networking.hostName = hostname; }
              baseConfig
              ./modules
              nix
              misc
            ];
          in
          channel.lib.nixosSystem {
            inherit system modules specialArgs pkgs;
          };
          
      };

      legacyPackages = forAllSystems
        ({ pkgs, ... }: pkgs);

      nixosModule = import ./modules;
      nixosModules = {
        desktop = import ./profiles/desktop;
        development = import ./profiles/development;
        laptop = import ./profiles/laptop;
        server = import ./profiles/server;
        tablet = import ./profiles/tablet;
      };

      packages = forAllSystems
        (import ./packages);

    };

}
