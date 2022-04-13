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
    ];
  };
}
