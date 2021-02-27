{ config, lib, pkgs, ... }:
let
  cfg = config.local;
in with pkgs.stdenv; with lib; {
  imports = [
    ./immutable
    ./lib
    ./services
    ./users
  ];

  config = {
    security.sudo.enable = true;

    time.timeZone = mkDefault "utc";
  };
}
