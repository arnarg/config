{ config, lib, pkgs, ... }:
let
  cfg = config.local;
in with pkgs.stdenv; with lib; {
  imports = [
    ./lib
    ./profiles
    ./desktop
    ./development
    ./services
  ];

  options.local = {
    userName = mkOption {
      type = types.str;
      default = "arnar";
      description = "Username to use. Required for my work macbook.";
    };
  };

  config = {

    nix.trustedUsers = [ "root" cfg.userName ];

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
        allowUnsupportedSystem = false;

        packageOverrides = pkgs: {
          mypkgs = import ../packages { inherit pkgs; };
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

    users.users.${cfg.userName} = {
      name = cfg.userName;
      home =
        if isDarwin then "/Users/${cfg.userName}"
        else "/home/${cfg.userName}";
    };

  };
}
