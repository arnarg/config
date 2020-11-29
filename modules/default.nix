{ config, lib, pkgs, ... }:
let
  cfg = config.local;
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz;
in with pkgs.stdenv; with lib; {
  imports = [
    "${home-manager}/nixos"
    ./desktop
    ./development
    ./lib
    ./profiles
    ./programs
    ./services
    ./users
  ];

  config = {

    nix.trustedUsers = [ "root" "arnar" ];
    nix.binaryCaches = [ "https://arnarg.cachix.org" ];
    nix.binaryCachePublicKeys = [ "arnarg.cachix.org-1:QwvsbygCMQHexg8JVwILYFrZwnWwMfH08O8SH6HsVaw=" ];

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
        allowUnsupportedSystem = false;

        packageOverrides = pkgs: {
          mypkgs = import ../packages { inherit pkgs lib; };
        };
      };

      # This was copied from https://github.com/jwiegley/nix-config
      overlays =
        let path = ../overlays; in with builtins;
        map (n: import (path + ("/" + n)){inherit config;})
            (filter (n: match ".*\\.nix" n != null ||
                        pathExists (path + ("/" + n + "/default.nix")))
                    (attrNames (readDir path)));
    };

    time.timeZone = mkDefault "Europe/Vienna";
  };
}
