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

  # I'm using a stable version of home-manager with
  # untable channel of nixpkgs.
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    terraform
    terragrunt
    awscli
  ];

  # Load work git config
  programs.git.includes = [
    {
      condition = "gitdir:~/Code/work/";
      path = "~/Code/work/.gitconfig";
    }
    {
      condition = "gitdir:~/Code/bnt/";
      path = "~/Code/bnt/.gitconfig";
    }
  ];

  # Set smaller icon size in dock
  dconf.settings."org/gnome/shell/extensions/dash-to-dock".dash-max-icon-size = 54;
  # Enable fractional scaling
  dconf.settings."org/gnome/mutter".experimental-features = ["scale-monitor-framebuffer"];

  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
