{ config, lib, pkgs, ... }:
{
  imports = [
    ./alacritty
    ./firefox
    ./spotify
  ];

  config = {
    home.packages = with pkgs; [
      obsidian
      logseq
      morgen
    ];

    services.syncthing.enable = true;
  };
}
