{
  config,
  lib,
  pkgs,
  homeModules,
  ...
}: {
  imports = [
    homeModules.development
    homeModules.desktop
    ./desktop/gnome
    ./desktop/tpm-fido
  ];

  home.username = "arnar";
  home.homeDirectory = "/home/arnar";

  # I'm using a stable version of home-manager with
  # untable channel of nixpkgs.
  home.enableNixpkgsReleaseCheck = false;

  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
