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

  # Load work git config
  programs.git.includes = [
    {
      condition = "gitdir:~/Code/work/";
      path = "~/Code/work/.gitconfig";
    }
  ];

  # Set smaller icon size in dock
  dconf.settings."org/gnome/shell/extensions/dash-to-dock".dash-max-icon-size = 54;

  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
