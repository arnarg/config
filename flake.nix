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
  outputs = inputs:
    let
      config = {allowUnfree = true;};
      pkgsFor = pkgs: system:
        import pkgs {
          inherit system config;
          # This was copied from https://github.com/jwiegley/nix-config
          overlays =
            let path = ./overlays; in with builtins;
            map (n: import (path + ("/" + n)){inherit config;})
                (filter (n: match ".*\\.nix" n != null ||
                            pathExists (path + ("/" + n + "/default.nix")))
                        (attrNames (readDir path)));
        };
    in
    {
      nixosConfigurations = {
        flex = 
          let
            system = "x86_64-linux";
            pkgs = pkgsFor inputs.nixpkgs system;
          in inputs.self.lib.mkMachine {
            inherit system pkgs;
            hostname = "flex";
            profiles = [
              "desktop"
              "laptop"
              "tablet"
              "development"
            ];
          };
      };

      lib = {
        mkMachine =
          { system
          , pkgs
          , hostname
          , profiles ? []
          , extraModules ? []
          }:
          let
            inherit (pkgs) lib;

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
                '';

                nixPath = [
                  "pkgs=${inputs.self}/compat"
                  "nixos-config=${inputs.self}/compat/nixos"
                ];

                registry = {
                  self.flake = inputs.self;

                  nixpkgs = {
                    from = { id = "nixpkgs"; type = "indirect"; };
                    flake = inputs.nixpkgs;
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
              ( ./machines + "/${hostname}/configuration.nix" )
              ./modules
              nix
              misc
            ];
          in
          inputs.nixpkgs.lib.nixosSystem {
            inherit system modules specialArgs pkgs;
          };
          
      };
    };

}
