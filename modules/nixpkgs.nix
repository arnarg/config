{ config, pkgs, ... }:
{
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
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };
}
