let
  pkgs = import (builtins.fetchTarball "https://nixos.org/channels/nixos-20.09/nixexprs.tar.xz") {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;

      packageOverrides = pkgs: {
        mypkgs = import ../packages { inherit pkgs; };
      };
    };
  };
in
{
  network =  {
    inherit pkgs;
    description = "my nas";
  };

  "192.168.0.10" = import ../machines/terramaster/configuration.nix;
}
