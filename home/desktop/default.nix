{ config, lib, pkgs, ... }:
{
  imports = [
    ./alacritty
    ./firefox
    ./spotify
  ];

  config = {
    home.packages = with pkgs; [
      anytype
      obsidian
      logseq
    ];

    services.syncthing.enable = true;
  };
}
