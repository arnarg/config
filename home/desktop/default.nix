{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./firefox
    ./spotify
  ];

  config = {
    home.packages = with pkgs; [
      obsidian
      anytype
      morgen
      mailspring
    ];
  };
}
