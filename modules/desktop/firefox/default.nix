{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.firefox;
  userName = config.local.userName;
in with lib; {
  options.local.desktop.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {

    home-manager.users.${userName} = {
      programs.firefox.enable = true;
      programs.firefox.package = pkgs.firefox-wayland;
    };

  };
}
