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
      channels = with inputs; {
        pkgs = nixpkgs;
        modules = nixpkgs;
        lib = nixpkgs;
      }; inherit (channels.lib) lib;

      config = {
        allowUnfree = true;
      };

      pkgsFor = pkgs: system:
        import pkgs {
          inherit system config;
        };

      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      allSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: genAttrs allSystems
        (system: f {
          inherit system;
          pkgs = pkgsFor inputs.nixpkgs system;
        });

      forOneSystem = system: f: f {
        inherit system;
        pkgs = pkgsFor inputs.nixpkgs system;
      };

      hm-nixos-as-super = { config, ... }: {
          # Submodules have merge semantics, making it possible to amend
          # the `home-manager.users` submodule for additional functionality.
          options.home-manager.users = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submoduleWith {
              modules = [ ];
              # Makes specialArgs available to Home Manager modules as well.
              specialArgs = {
                inherit inputs;
                # Allow accessing the parent NixOS configuration.
                super = config;
              };
            });
          };
        };

      mkSystem =
        { system
        , pkgs
        , hostname
        , extraModules ? [ ]
        }:
        let
          inherit (pkgs) lib;

          nix = { ... }: {
            nix = {
              package = lib.mkForce inputs.nix.defaultPackage.${system};

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
            mypkgs = import ./packages { inherit pkgs; };
          };

          misc = { ... }: {
            _module.args = specialArgs;
            nixpkgs.pkgs = pkgs;

            nix.trustedUsers = [ "root" "arnar" ];
            nix.binaryCaches = [ "https://arnarg.cachix.org" ];
            nix.binaryCachePublicKeys = [ "arnarg.cachix.org-1:QwvsbygCMQHexg8JVwILYFrZwnWwMfH08O8SH6HsVaw=" ];
          };

          modules = extraModules ++ [
            { networking.hostName = hostname; }
            (./machines + "/${hostname}/configuration.nix")
            nix
            misc
          ];

        in
        inputs.nixpkgs.lib.nixosSystem {
          inherit system modules specialArgs pkgs;
        };
    in
    {
      nixosConfigurations = {

        ##########
        ## FLEX ##
        ##########
        flex =
          let
            system = "x86_64-linux";
            pkgs = pkgsFor inputs.nixpkgs system;
          in
          mkSystem {
            inherit system pkgs;
            hostname = "flex";
            extraModules =
              let
                inherit (inputs.home.nixosModules) home-manager;
              in
              [
                home-manager
              ];
          };

      };

      legacyPackages = forAllSystems
        ({ pkgs, ... }: pkgs);

      defaultPackage = forAllSystems
        ({ system, ... }:
          inputs.self.packages.${system}.flex);
    };

}
