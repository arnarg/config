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
    azure-cli
    chromium
    obsidian
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
  # Enable fractional scaling
  dconf.settings."org/gnome/mutter".experimental-features = ["scale-monitor-framebuffer"];

  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
