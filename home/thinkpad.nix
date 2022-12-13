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
  ];

  home.username = "arnar";
  home.homeDirectory = "/home/arnar";

  home.packages = with pkgs; [
    teams
    slack
    terraform
  ];

  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
